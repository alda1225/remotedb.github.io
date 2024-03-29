import 'package:flutter/material.dart';
import 'package:permisos/models/scripts.dart';

import '../../models/conection.dart';
import '../../utils/utils.dart';
import '../widget/widget.dart';
import 'form_script.dart';
import 'dart:developer' as developer;
import 'package:sizer/sizer.dart';

class AppScript extends StatefulWidget {
  final Connection? conn;
  const AppScript({super.key, required this.conn});

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

      developer.log("INICIALIZA: listConexiones: ${listConexiones.length}");
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
          if (script.idPadre == widget.conn!.nombre) {
            listScript.add(script);
          }
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

    Future<void> showDeleteDialog(Script? script) async {
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
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
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete_outline_rounded),
                        style: Widgets.elevatedButtonPrimary(),
                        onPressed: () async {
                          Connection conn = listConexiones.firstWhere((i) => i.nombre == script?.idPadre);
                          int indexConexion = listConexiones.indexOf(conn);
                          listConexiones[indexConexion].script?.remove(script);

                          utils.guardar(listConexiones);

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            Widgets.snackBar("success", 'Eliminado correctamente'),
                          );
                        },
                        label: const Text(
                          "Eliminar",
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

    Future<void> showInformationDialog(Script? scripts) async {
      return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            alignment: Alignment.bottomCenter,
            elevation: 0,
            insetPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 475,
              width: widht,
              padding: const EdgeInsets.all(5),
              child: FormScript(script: scripts, listConexiones: listConexiones, idConn: widget.conn!.nombre),
            ),
          );
        },
      );
    }

    //final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      //drawer: const HomeDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 5, top: 30, right: 0, bottom: 10),
            child: Row(
              children: [
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 26,
                    color: Color(0xFF4C53A5),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    "DBQuery",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.89,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(
                      "Scripts - ${widget.conn?.nombre}",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C53A5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: listScript.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 165,
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  /*Container(
                                    height: 50,
                                    width: 50,
                                    margin: const EdgeInsets.only(right: 15),
                                    child: Image.asset("images/script.png"),
                                  ),*/
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                            Icons.insert_drive_file_outlined,
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
                                            Icons.cloud_queue,
                                            color: Color(0xFF4C53A5),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: Text(
                                              listScript[index].idPadre ?? "",
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
                                              listScript[index],
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
                                              listScript[index],
                                            );
                                            developer.log('Salio del modal');
                                            await listaScripts();
                                          },
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.play_arrow_outlined, size: 5.w),
                                    style: Widgets.elevatedButtonSuccess(),
                                    onPressed: () async {
                                      bool conexionDatabase = await utils.connectDatabase(context, widget.conn);

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
                                    label: Text(
                                      "Ejecutar",
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 3.8.w),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showInformationDialog(
            null,
          );
          developer.log('Salio del modal');
          await listaScripts();
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // T
    );
  }
}
