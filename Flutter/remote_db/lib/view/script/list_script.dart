import 'package:flutter/material.dart';
import 'package:permisos/models/scripts.dart';
import 'package:permisos/view/home_app_bar.dart';

import '../../models/conection.dart';
import '../../utils/utils.dart';
import '../home_drawer.dart';
import '../widget/widget.dart';
import 'form_script.dart';
import 'dart:developer' as developer;
import 'package:sql_conn/sql_conn.dart';

class AppScript extends StatefulWidget {
  const AppScript({super.key});

  @override
  State<AppScript> createState() => _AppState();
}

Utils utils = Utils();
List<Script> listScript = [];
List<Connection> listConexiones = [];

class _AppState extends State<AppScript> {
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

    Future<void> showInformationDialog(Script scripts) async {
      return await showDialog(
        context: context,
        barrierColor: Colors.white,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 665,
              width: widht,
              padding: const EdgeInsets.all(5),
              child: FormScript(script: scripts, listConexiones: listConexiones),
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
                      vertical: 0,
                      horizontal: 20,
                    ),
                    child: const Text(
                      "Listado scripts",
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
                      padding: const EdgeInsets.all(8),
                      itemCount: listScript.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 145,
                          margin: const EdgeInsets.all(10),
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
                                    child: Image.asset("images/script.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.assignment,
                                              color: Color(0xFF4C53A5),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              child: Text(
                                                "${listScript[index].nombre}",
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
                                            Icons.storage_outlined,
                                            color: Color(0xFF4C53A5),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: Text(
                                              listScript[index].descripcion ?? "",
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
                                            Icons.insert_drive_file_outlined,
                                            color: Color(0xFF4C53A5),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: Text(
                                              listScript[index].scriptString ?? "",
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
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.play_arrow_outlined),
                                    style: Widgets.elevatedButtonSuccess(),
                                    onPressed: () async {
                                      bool conexionDatabase = await utils.connectDatabase(context, listConexiones[0]);
                                      if (conexionDatabase) {
                                        if (listScript[index].scriptString!.toLowerCase().contains('select')) {
                                          //execute query for select
                                          await utils.read(context, listScript[index].scriptString!);
                                        } else {
                                          //execute query for select
                                          await utils.write(context, listScript[index].scriptString!);
                                        }
                                      }
                                    },
                                    label: const Text(
                                      "Ejecutar",
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.edit),
                                    style: Widgets.elevatedButtonWarning(),
                                    onPressed: () async {
                                      await showInformationDialog(
                                        listScript[index],
                                      );
                                      developer.log('Salio del modal');
                                      await listaScripts();
                                    },
                                    label: const Text(
                                      "Editar",
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.delete),
                                    style: Widgets.elevatedButtonError(),
                                    onPressed: () {},
                                    label: const Text(
                                      "Eliminar",
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
