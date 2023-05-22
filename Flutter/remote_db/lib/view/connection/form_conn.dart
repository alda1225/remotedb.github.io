import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';

class FormConn extends StatefulWidget {
  const FormConn({Key? key}) : super(key: key);

  @override
  State<FormConn> createState() {
    return _AppState();
  }
}

class _AppState extends State<FormConn> {
  final formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController(text: '192.168.50.80');
  final _puertoController = TextEditingController(text: '1433');
  final _databaseController = TextEditingController(text: 'aldadb');
  final _userController = TextEditingController(text: 'sa');
  final _passController = TextEditingController(text: 'asql');
  final _scriptController = TextEditingController(text: "update person set estado='null' where name='asdd'");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    const double spaceHeight = 20;

    Future<void> connect(BuildContext ctx) async {
      debugPrint("Connecting...");

      try {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Loading"),
              content: CircularProgressIndicator(strokeWidth: 5),
            );
          },
        );

        await SqlConn.connect(
            ip: _hostController.text,
            port: _puertoController.text,
            databaseName: _databaseController.text,
            username: _userController.text,
            password: _passController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Conexion exitosa!  Server=${_hostController.text};Database=${_databaseController.text};User Id=${_userController.text};Password=${_passController.text};',
            ),
            backgroundColor: Colors.green.shade300,
            duration: const Duration(seconds: 5),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Conexion fallida! $e | Server=${_hostController.text};Database=${_databaseController.text};User Id=${_userController.text};Password=${_passController.text};'),
            backgroundColor: Colors.red.shade300,
            duration: const Duration(seconds: 5),
          ),
        );
        debugPrint(e.toString());
      } finally {
        Navigator.pop(context);
      }
    }

    Future<void> read(String query) async {
      try {
        var res = await SqlConn.readData(query);
        debugPrint(res.toString());

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ejecucion exitosa: $res'),
          backgroundColor: Colors.greenAccent,
          duration: const Duration(seconds: 5),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo ejecutar: $query | $e'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );

        debugPrint(e.toString());
      }
    }

    Future<void> write(String query) async {
      try {
        var res = await SqlConn.writeData(query);
        debugPrint(res.toString());

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ejecucion exitosa: $res'),
          backgroundColor: Colors.greenAccent,
          duration: const Duration(seconds: 5),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo ejecutar! $query | $e'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );

        debugPrint(e.toString());
      }
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFffffff),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: formKey, //key for form
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spaceHeight),
                TextFormField(
                  controller: _hostController,
                  decoration: const InputDecoration(
                    labelText: "Host/Ip",
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese el Hosst/Ip";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: spaceHeight),
                TextFormField(
                  controller: _puertoController,
                  decoration: const InputDecoration(
                    labelText: "Puerto",
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
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
                  controller: _databaseController,
                  decoration: const InputDecoration(
                    labelText: "Database",
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
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
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: "Usuario",
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
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
                  controller: _passController,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese una contraseña";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: spaceHeight),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        //connect(context);
                      } else {
                        //connect(context);
                      }
                    },
                    child: const Text(
                      "Probar",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(height: spaceHeight),
                TextFormField(
                  controller: _scriptController,
                  keyboardType: TextInputType.multiline,
                  minLines: 3, //Normal textInputField will be displayed
                  maxLines: null, // when user presses enter it will adapt to it
                  decoration: const InputDecoration(
                    labelText: "Script",
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese una script";
                    } else {
                      return null;
                    }
                  },*/
                ),
                const SizedBox(height: spaceHeight),
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (!SqlConn.isConnected) {
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
                        }
                      }
                    },
                    child: const Text(
                      "Probar",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
