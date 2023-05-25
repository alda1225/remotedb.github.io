import 'package:flutter/material.dart';
import 'package:permisos/models/scripts.dart';
import 'package:permisos/view/home_app_bar.dart';

import '../../models/conection.dart';
import '../../utils/utils.dart';
import '../home_drawer.dart';
import '../widget/widget.dart';
import 'dart:developer' as developer;
import 'package:sql_conn/sql_conn.dart';

import 'form_conn.dart';

class AppConection extends StatefulWidget {
  const AppConection({super.key});

  @override
  State<AppConection> createState() => _AppState();
}

Utils utils = Utils();
List<Script> listScript = [];
List<Connection> listConexiones = [];

class _AppState extends State<AppConection> {
  @override
  void initState() {
    super.initState();
    try {
      init();
    } catch (e) {
      developer.log('Exception init() $e');
    }
  }

  Future init() async {
    try {
      listConexiones = await utils.loadConnection();
      if (listConexiones.isEmpty) {
        utils.createExample();
        listConexiones = await utils.loadConnection();
      }

      await listaScripts();

      developer.log("INICIALIZA: listConexiones:${listConexiones.length}");
    } catch (e) {
      developer.log('Exception init() $e');
    }
  }

  Future<void> listaScripts() async {
    try {
      developer.log("listaScripts");

      listScript.clear();
      for (Connection item in listConexiones) {
        for (Script script in item.script ?? []) {
          listScript.add(script);
        }
      }

      setState(() {});
    } catch (e) {
      developer.log('listaScripts() $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double widht = MediaQuery.of(context).size.width;

    Future<void> showDeleteDialog(Connection? conn) async {
      return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            alignment: Alignment.bottomCenter,
            elevation: 0,
            insetPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 185,
              width: widht,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: const Text(
                          "Eliminar conexión",
                          style: TextStyle(
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
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "¿Esta seguro que desea eliminar este registro? Este proceso no se puede deshacer.",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete_outline_rounded),
                        style: Widgets.elevatedButtonPrimary(),
                        onPressed: () async {
                          try {
                            if (listConexiones.length == 1) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                Widgets.snackBar("error", 'No se pudo eliminar, debe tener al menos una conexión activa.'),
                              );
                              return;
                            }
                            listConexiones.remove(conn);
                            utils.guardar(listConexiones);

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              Widgets.snackBar("success", 'Eliminado correctamente'),
                            );
                          } catch (e) {
                            developer.log('Exception delete() $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              Widgets.snackBar(
                                "error",
                                'Exception delete() $e',
                              ),
                            );
                          }
                        },
                        label: const Text(
                          "Eliminar",
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
        },
      );
    }

    Future<void> showInformationDialog(Connection? conn) async {
      return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            alignment: Alignment.bottomCenter,
            elevation: 0,
            insetPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 560,
              width: widht,
              padding: const EdgeInsets.all(5),
              child: FormConn(conn: conn, listConexiones: listConexiones),
            ),
          );
        },
      );
    }

    //final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: const HomeDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const HomeAppBar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: const Text(
                      "Listado conexiones",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(5),
                      itemCount: listConexiones.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 120,
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    margin: const EdgeInsets.only(right: 15),
                                    child: Image.asset("images/sql-icon.jpg"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.account_box_outlined,
                                              color: Color(0xFF4C53A5),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              child: Text(
                                                "${listConexiones[index].nombre}",
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(children: [
                                          const Icon(
                                            Icons.text_snippet_outlined,
                                            color: Color(0xFF4C53A5),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Text(
                                              listConexiones[index].hostIp ?? "",
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ]),
                                        Row(children: [
                                          const Icon(
                                            Icons.person,
                                            color: Color(0xFF4C53A5),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Text(
                                              listConexiones[index].user ?? "",
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ]),
                                        Row(children: [
                                          const Icon(
                                            Icons.storage_outlined,
                                            color: Color(0xFF4C53A5),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Text(
                                              listConexiones[index].database ?? "",
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ]),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_note_rounded, size: 28),
                                          onPressed: () async {
                                            await showInformationDialog(
                                              listConexiones[index],
                                            );
                                            developer.log('Salio del modal');
                                            await listaScripts();
                                          },
                                          color: Colors.orange,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline_rounded, size: 25),
                                          onPressed: () async {
                                            await showDeleteDialog(
                                              listConexiones[index],
                                            );
                                            developer.log('Salio del modal');
                                            await listaScripts();
                                          },
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 45)
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showInformationDialog(
            null,
          );
          developer.log('Salio del modal');
          await listaScripts();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // Th
    );
  }
}
