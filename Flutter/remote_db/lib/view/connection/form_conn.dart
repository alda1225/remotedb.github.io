import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permisos/models/conection.dart';
import 'package:permisos/models/scripts.dart';
import 'package:permisos/utils/utils.dart';
import 'package:sql_conn/sql_conn.dart';
import 'dart:developer' as developer;

import '../widget/widget.dart';

class FormConn extends StatefulWidget {
  final Connection? conn;
  final List<Connection> listConexiones;
  const FormConn({Key? key, this.conn, required this.listConexiones}) : super(key: key);

  @override
  State<FormConn> createState() {
    return _AppState();
  }
}

class _AppState extends State<FormConn> {
  Utils utils = Utils();
  final formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _hostController = TextEditingController();
  final _puertoController = TextEditingController();
  final _databaseController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  String connSelect = "";
  Connection connSeleccionado = Connection();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conn != null) {
      connSelect = widget.conn?.nombre ?? "";
      connSeleccionado = widget.listConexiones.firstWhere((i) => i.nombre == connSelect);

      _nombreController.text = widget.conn?.nombre ?? "";
      _hostController.text = widget.conn?.hostIp ?? "";
      _puertoController.text = widget.conn?.port ?? "";
      _databaseController.text = widget.conn?.database ?? "";
      _userController.text = widget.conn?.user ?? "";
      _passController.text = widget.conn?.pass ?? "";
    } else {
      _nombreController.text = "";
      _hostController.text = "";
      _puertoController.text = "";
      _databaseController.text = "";
      _userController.text = "";
      _passController.text = "";
    }

    bool validaNombre() {
      for (Connection conn in widget.listConexiones) {
        if (conn.nombre!.trim().toUpperCase() == _nombreController.text.trim().toUpperCase()) {
          ScaffoldMessenger.of(context).showSnackBar(
            Widgets.snackBar("error", 'El nombre ya esta en uso'),
          );
          return false;
        }
      }
      return true;
    }

    Future<bool> save() async {
      try {
        Connection model = Connection(
          nombre: _nombreController.text,
          database: _databaseController.text,
          hostIp: _hostController.text,
          port: _puertoController.text,
          user: _userController.text,
          pass: _passController.text,
          script: [],
        );

        if (widget.conn == null) {
          developer.log('nuevo');
          //Valida nombre
          if (!validaNombre()) {
            return false;
          }

          widget.listConexiones.add(model);
          utils.guardar(widget.listConexiones);
          ScaffoldMessenger.of(context).showSnackBar(
            Widgets.snackBar("success", 'Registrado correctamente'),
          );
          return true;
        } else {
          developer.log('edit');
          //Valida nombre
          if (_nombreController.text.trim().toUpperCase() != connSelect.trim().toUpperCase() && !validaNombre()) {
            return false;
          }

          int indexConexion = widget.listConexiones.indexOf(connSeleccionado);

          //Actializa scripts
          List<Script> listScriptActualizada = [];
          for (Script script in widget.listConexiones[indexConexion].script ?? []) {
            script.idPadre = _nombreController.text;
            listScriptActualizada.add(script);
          }

          model.script = listScriptActualizada;
          widget.listConexiones[indexConexion] = model;

          utils.guardar(widget.listConexiones);

          ScaffoldMessenger.of(context).showSnackBar(
            Widgets.snackBar("success", 'Modificado correctamente'),
          );
          return true;
        }
      } catch (e) {
        developer.log('Exception saveScript() $e');
        ScaffoldMessenger.of(context).showSnackBar(
          Widgets.snackBar("error", 'Exception loadConnection() $e'),
        );
        return false;
      }
    }

    //final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    const double spaceHeight = 20;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFffffff),
      body: Container(
        height: 650,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    widget.conn == null ? "Nueva conexión" : "Editar conexión",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close_outlined),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Form(
                    key: formKey, //key for form
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const SizedBox(height: spaceHeight),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _nombreController,
                          decoration: Widgets.inputDecorations("Nombre"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ingrese el nombre";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: spaceHeight),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          controller: _hostController,
                          decoration: Widgets.inputDecorations("Host/Ip"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ingrese el Host/Ip";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: spaceHeight),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          controller: _puertoController,
                          decoration: Widgets.inputDecorations("Puerto"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ingrese el puerto";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: spaceHeight),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _databaseController,
                          decoration: Widgets.inputDecorations("Database"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ingrese una base de datos";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: spaceHeight),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _userController,
                          decoration: Widgets.inputDecorations("Usuario"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ingrese un usuario";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: spaceHeight),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: _passController,
                          decoration: Widgets.inputDecorations("Contraseña"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ingrese una contraseña";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: spaceHeight),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 5),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow_outlined),
                  style: Widgets.elevatedButtonPrimary(),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Connection model = Connection(
                        nombre: _nombreController.text,
                        database: _databaseController.text,
                        hostIp: _hostController.text,
                        port: _puertoController.text,
                        user: _userController.text,
                        pass: _passController.text,
                      );

                      await utils.connectDatabase(context, model);
                    }
                  },
                  label: const Text(
                    "Probar",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_outlined),
                  style: Widgets.elevatedButtonSuccess(),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bool guardadoCorrectamente = await save();
                      if (guardadoCorrectamente) {
                        Navigator.pop(context);
                      }

                      /*if (!SqlConn.isConnected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo conectar, pruebe dar primero al boton de Probar Conexión'),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 5),
                          ),
                        );
                        return;
                      }

                      if (_scriptController.text.toLowerCase().contains('select')) {
                        //execute query for select
                        read(_scriptController.text);
                      } else {
                        //execute query for select
                        write(_scriptController.text);
                      }*/
                    }
                  },
                  label: const Text(
                    "Guardar",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.close_outlined),
                  style: Widgets.elevatedButtonError(),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  label: const Text(
                    "Cancelar",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
