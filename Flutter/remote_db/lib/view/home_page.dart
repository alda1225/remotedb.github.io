//import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:client_information/client_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permisos/view/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer' as developer;
import 'package:sizer/sizer.dart';

import 'connection/list_conn.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppState();
}

final formKey = GlobalKey<FormState>();
final _identificadorController = TextEditingController();
final _codigoEncriptadoController = TextEditingController();
final _checkCacheController = TextEditingController();
//final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//String _host = "";
//String _id = "";
String nameDevice = "";
ClientInformation? _clientInfo;

class _AppState extends State<AppHomePage> {
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
      //_host = hostDevice(await deviceInfoPlugin.androidInfo);
      //_id = idDevice(await deviceInfoPlugin.androidInfo);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ClientInformation? info;
      final bool? cache = prefs.getBool('cache');
      if (cache != null && cache == true) {}

      final String? codigo = prefs.getString('codigo');
      if (cache != null && cache == true) {}

      try {
        info = await ClientInformation.fetch();
        _clientInfo = info;
        nameDevice = _clientInfo?.deviceName ?? 'nameDevice - sin definir.';
      } on PlatformException {
        nameDevice = 'nameDevice - sin definir.';
        _identificadorController.text = "No se pudo definir su IDENTIFICADOR.";
        _codigoEncriptadoController.text = "No se pudo definir su IDENTIFICADOR.";

        ScaffoldMessenger.of(context).showSnackBar(Widgets.snackBar("error", 'No se pudo definir su IDENTIFICADOR.'));
        return;
      }

      _identificadorController.text = _clientInfo?.deviceId ?? 'No se pudo definir su IDENTIFICADOR.';
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(Widgets.snackBar("error", 'Exception init() $e'));
      developer.log('Exception init() $e');
    }
  }

  /*String hostDevice(AndroidDeviceInfo build) {
    return build.serialNumber;
  }

  String idDevice(AndroidDeviceInfo build) {
    return build.serialNumber;
  }*/

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double widht = MediaQuery.of(context).size.width;

    //final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      //drawer: const HomeDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFEDECF2),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 345,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              //color: Colors.white,
              child: Form(
                key: formKey, //key for form
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        "Control de acceso", //- id:$_id",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4C53A5).withOpacity(0.9),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        nameDevice, //- id:$_id",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF4C53A5).withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //const SizedBox(height: spaceHeight),
                    Row(
                      children: [
                        SizedBox(
                          width: widht * 0.56,
                          child: TextFormField(
                            readOnly: true,
                            controller: _identificadorController,
                            //initialValue: _identificadorController.text,
                            decoration: Widgets.inputDecorations("Identificador"),
                            /*validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Ingrese el nombre";
                              } else {
                                return null;
                              }
                            },*/
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.copy, size: 4.w),
                          style: Widgets.buttonPrimary2(),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: _identificadorController.text));
                          },
                          label: Text(
                            "Copiar",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.w),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _codigoEncriptadoController,
                      decoration: Widgets.inputDecorations("Código"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese el código de verificación";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.security_outlined, size: 5.w),
                          style: Widgets.buttonPrimary(),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              String ip = "";
                              String puerto = "";

                              //String entrada = '192.168.10.190';
                              String entrada = utils.desencriptarClave(_codigoEncriptadoController.text);
                              List<String> partes = entrada.split(':');

                              if (partes.length > 1) {
                                ip = partes[0];
                                puerto = partes[1];
                                print('IP: $ip:$puerto');
                              } else {
                                ip = entrada;
                                puerto = "80";
                                print('IP: $ip');
                              }

                              Socket.connect(ip, int.parse(puerto), timeout: Duration(seconds: 3)).then((socket) {
                                print("connect success");
                                socket.destroy();

                                //Redirecting to App
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => const AppConection(),
                                  ),
                                );
                              }).catchError((error) {
                                print(error.toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  Widgets.snackBar("error", "No se pudo conectar: $entrada"),
                                );
                              });
                            }
                          },
                          label: Text(
                            "INICIAR  ",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.w),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
