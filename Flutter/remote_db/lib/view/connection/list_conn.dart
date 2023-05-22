import 'package:flutter/material.dart';
import 'package:permisos/utils/utils.dart';
import 'package:permisos/view/connection/form_conn.dart';
import 'package:permisos/view/home_app_bar.dart';

import '../../models/conection.dart';
import '../../models/scripts.dart';
import '../home_drawer.dart';

import 'dart:developer' as developer;

class AppConection extends StatefulWidget {
  const AppConection({super.key});

  @override
  State<AppConection> createState() => _AppState();
}

List<Script> script = [];
List<Connection> listConexiones = [];
Utils utils = Utils();

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
      }
      developer.log("INCIALIZOLAO: listConexiones=${listConexiones.length}");
    } catch (e) {
      developer.log('Exception init() $e');
    }
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 700,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            child: const Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "Editar script",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Expanded(child: FormConn()),
                Text(
                  "BOTONES",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: HomeDrawer(),
      body: Column(
        children: [
          HomeAppBar(),
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
                      vertical: 4,
                      horizontal: 20,
                    ),
                    child: const Text(
                      "Listado conexiones",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: listConexiones.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 165,
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
                                      height: 70,
                                      width: 70,
                                      margin: const EdgeInsets.only(right: 15),
                                      child: Image.asset("images/script.png"),
                                    ),
                                    Container(
                                      width: (MediaQuery.of(context).size.width - 180),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.badge_outlined,
                                                color: Color(0xFF4C53A5),
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  strutStyle: StrutStyle(fontSize: 12.0),
                                                  text: TextSpan(
                                                    text: "Nombre conecctionasd as asddddas ",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black.withOpacity(0.78),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Row(children: [
                                            Icon(
                                              Icons.badge_outlined,
                                              color: Color(0xFF4C53A5),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Nombre conecction",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87,
                                              ),
                                            )
                                          ]),
                                          const Row(children: [
                                            Icon(
                                              Icons.badge_outlined,
                                              color: Color(0xFF4C53A5),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Nombre conecction",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87,
                                              ),
                                            )
                                          ]),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.play_arrow_outlined,
                                            color: Colors.green,
                                          ),
                                          Icon(
                                            Icons.edit_note_outlined,
                                            color: Colors.orange,
                                          ),
                                          Icon(
                                            Icons.delete_outline_outlined,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.play_arrow_outlined),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.all(15),
                                        foregroundColor: const Color(0xFF00C853),
                                        side: BorderSide(color: const Color(0xFF00C853).withOpacity(0.08)),
                                        backgroundColor: const Color(0xFF00C853).withOpacity(0.08),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                        shadowColor: Colors.white,
                                      ),
                                      onPressed: () {},
                                      label: const Text(
                                        "Ejecutar",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.edit),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.all(15),
                                        foregroundColor: const Color(0xFFff9800),
                                        side: BorderSide(color: const Color(0xFFff9800).withOpacity(0.08)),
                                        backgroundColor: const Color(0xFFff9800).withOpacity(0.08),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await showInformationDialog(context);
                                      },
                                      label: const Text(
                                        "Editar",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.delete),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.all(15),
                                        foregroundColor: const Color(0xFFf44336),
                                        side: BorderSide(color: const Color(0xFFf44336).withOpacity(0.08)),
                                        backgroundColor: const Color(0xFFf44336).withOpacity(0.08),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () {},
                                      label: const Text(
                                        "Eliminar",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
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
