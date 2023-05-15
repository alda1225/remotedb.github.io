import 'package:flutter/material.dart';

import 'connection.dart';

class ScriptApp extends StatelessWidget {
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
            child: Column(
              children: const [
                SizedBox(height: 10),
                Text(
                  "Editar script",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Expanded(child: CompleteForm()),
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
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: const Text(
            "Listado scripts",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            ),
          ),
        ),
        Container(
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
                        Row(children: const [
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
                        Row(children: const [
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
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
        )
      ],
    );
  }
}
