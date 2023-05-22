import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sql_conn/sql_conn.dart';
import '../models/conection.dart';
import 'dart:developer' as developer;

import '../models/scripts.dart';
import '../view/widget/widget.dart';

class Utils {
  void createExample() {
    try {
      developer.log("Crea conexion de ejemplo");

      // Añadir un registro de ejemplo a la lista de conexiones
      Connection conexion = Connection();
      conexion.nombre = "Conexión Example";
      conexion.hostIp = "192.168.50.80";
      conexion.port = "1433";
      conexion.database = "database";
      conexion.user = "sa";
      conexion.pass = "asql";

      // Añade un registro de ejemplo a la lista de conexiones
      Script script = Script();
      script.idPadre = "Conexión Example";
      script.nombre = "Script update rol";
      script.descripcion = "Script de ejemplo para actualizar un rol";
      script.scriptString = "update person set estado='null' where name='asdd;";

      // Añade ejemplo de script a la conexion de ejemplo
      conexion.script = [];
      conexion.script?.add(script);
      List<Connection> listConexiones = [];
      listConexiones.add(conexion);

      guardar(listConexiones);
    } catch (e) {
      developer.log('Exception loadConnection() $e');
    }
  }

  Future<bool> connectDatabase(BuildContext context, Connection conn) async {
    debugPrint("Connecting...");

    try {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Procesando..."),
            content: SizedBox(
              height: 40,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      );

      await SqlConn.connect(
        ip: conn.hostIp ?? "",
        port: conn.port ?? "",
        databaseName: conn.database ?? "",
        username: conn.user ?? "",
        password: conn.pass ?? "",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        Widgets.snackBar(
          "success",
          'Conexion exitosa!  Server=${conn.hostIp},${conn.port};Database=${conn.database};User Id=${conn.user};Password=${conn.pass};',
        ),
      );

      debugPrint("Conexion exitosa");
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Widgets.snackBar(
          "error",
          'Conexion fallida! $e | Server=${conn.hostIp},${conn.port};Database=${conn.database};User Id=${conn.user};Password=${conn.pass};',
        ),
      );

      debugPrint(e.toString());
      return false;
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> read(BuildContext context, String query) async {
    try {
      var res = await SqlConn.readData(query);
      debugPrint(res.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        Widgets.snackBar(
          "success",
          'Ejecucion exitosa: $res',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Widgets.snackBar(
          "error",
          'No se pudo ejecutar: $query | $e',
        ),
      );

      debugPrint(e.toString());
    }
  }

  Future<void> write(BuildContext context, String query) async {
    try {
      var res = await SqlConn.writeData(query);
      debugPrint(res.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        Widgets.snackBar(
          "error",
          'Ejecucion exitosa: $res',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Widgets.snackBar(
          "error",
          'No se pudo ejecutar! $query | $e',
        ),
      );

      debugPrint(e.toString());
    }
  }

  void guardar(List<Connection> connections) {
    try {
      final List<Map<String, dynamic>> connectionsJson = connections.map((connection) => connection.toJson()).toList();
      final jsonString = jsonEncode(connectionsJson);
      writeJson(jsonString);
    } catch (e) {
      developer.log('Exception loadConnection() $e');
    }
  }

  Future<List<Connection>> loadConnection() async {
    try {
      String? jsonConnection = await readJson();
      if (jsonConnection != null && jsonConnection.isNotEmpty) {
        final List<dynamic> parsedJson = json.decode(jsonConnection!);
        return parsedJson.map((jsonItem) => Connection.fromJson(jsonItem)).toList();
      }
      return [];
    } catch (e) {
      developer.log('Exception loadConnection() $e');
      return [];
    }
  }

  Future<File?> get _localFileTmp async {
    try {
      final directory = await getTemporaryDirectory();
      final path = directory.path;
      return File('$path/listConn.json');
    } catch (e) {
      developer.log('Exception _localFileTmp() $e');
      return null;
    }
  }

  Future<Future<File>?> writeJson(String json) async {
    try {
      final file = await _localFileTmp;
      return file?.writeAsString(json);
    } catch (e) {
      developer.log('Exception writeJson() $e');
      return null;
    }
  }

  Future<String?> readJson() async {
    try {
      final file = await _localFileTmp;
      bool? existFile = await file?.exists();
      if (existFile != null && existFile) {
        return file?.readAsString();
      } else {
        writeJson("");
      }
    } catch (e) {
      developer.log('Exception readJson() $e');
      return null;
    }
  }
}
