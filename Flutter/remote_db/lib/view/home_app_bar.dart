import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

import 'package:permisos/view/widget/widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/utils.dart';
import 'connection/list_conn.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _AppState();
}

class _AppState extends State<HomeAppBar> {
  @override
  void initState() {
    super.initState();
    try {
      initPlatformState();
    } catch (e) {
      developer.log('Exception init() $e');
    }
  }

  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    Utils utils = Utils();

    Future<bool> alertConfirm(BuildContext context) async {
      //check bundles

      return await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importar conexion'),
          content: const Text('¿Está seguro de que desea importar las conexiones? Esto implicará la sustitución de las conexiones y configuraciones actuales.'),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.close_outlined),
              style: Widgets.elevatedButtonError(),
              onPressed: () {
                Navigator.pop(context, false);
              },
              label: const Text(
                "Cancelar",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.sync_outlined),
              style: Widgets.elevatedButtonPrimary(),
              onPressed: () async {
                Navigator.pop(context, true);
              },
              label: const Text(
                "Continuar",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
              ),
            ),
          ],
          elevation: 24,
        ),
        barrierDismissible: false,
      ).then(
        (value) {
          return value ?? false;
        },
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 5, top: 30, right: 0, bottom: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.sort,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              "RemoteDB",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            //initialValue: "1",
            onSelected: (String item) async {
              bool dirDownloadExists = true;
              String pathDownload = "/storage/emulated/0/Download/";

              dirDownloadExists = await Directory(pathDownload).exists();
              if (!dirDownloadExists) {
                pathDownload = "/storage/emulated/0/Downloads/";
              }

              if (item == "1") {
                bool? confirm = await alertConfirm(context);

                if (!confirm) {
                  return;
                }

                final result;
                dirDownloadExists = await Directory(pathDownload).exists();
                if (dirDownloadExists) {
                  result = await FilePicker.platform.pickFiles(
                    allowedExtensions: ['json'],
                    initialDirectory: pathDownload,
                    allowMultiple: false,
                    type: FileType.custom,
                  );
                } else {
                  result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['json'],
                  );
                }

                if (result == null) return;

                //Archivo origen
                print(result.files.first.path);
                File? sourceFile = File(result.files.first.path);
                List<int> content = sourceFile.readAsBytesSync();

                //Archivo destino
                File? destinationFile = await utils.localFileTmp();
                destinationFile!.writeAsBytesSync(content);

                print('Archivo copiado exitosamente de $sourceFile a $destinationFile');

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AppConection(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  Widgets.snackBar("success", 'Archivo importado exitosamente'),
                );
              } else {
                final permission = Permission.storage;
                final status = await permission.status;
                debugPrint('>>> Permission.storage - Status $status');
                if (status != PermissionStatus.granted) {
                  await permission.request();
                  if (await permission.status.isGranted) {
                  } else {
                    await permission.request();
                  }
                  debugPrint('>>>  Permission.storage -  ${await permission.status}');
                } else if (status == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    Widgets.snackBar(
                      "error",
                      'No cuenta con los permisos necesarios. Le recomendamos acceder a la configuración y otorgar los permisos correspondientes',
                    ),
                  );
                  return;
                }

                final permissionStorage = Permission.manageExternalStorage;
                final statusStorage = await permissionStorage.status;
                debugPrint('>>> Permission.manageExternalStorage - Status $statusStorage');
                if (statusStorage != PermissionStatus.granted) {
                  await permissionStorage.request();
                  if (await permissionStorage.status.isGranted) {
                  } else {
                    await permissionStorage.request();
                  }
                  debugPrint('>>> Permission.manageExternalStorage - ${await permissionStorage.status}');
                } else if (statusStorage == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    Widgets.snackBar(
                      "error",
                      'No cuenta con los permisos necesarios. Le recomendamos acceder a la configuración y otorgar los permisos correspondientes',
                    ),
                  );
                  return;
                }

                DateTime now = DateTime.now();
                String formattedDate = DateFormat('MM-yyyy').format(now);
                String formattedTime = DateFormat('HHmm').format(now);
                String fechaHora = '$formattedDate-$formattedTime';
                //Archivo origen
                File? sourceFile = await utils.localFileTmp();
                List<int> content = sourceFile!.readAsBytesSync();

                //Archivo destino
                final destinationFile = File('${pathDownload}bk_connection $fechaHora.json');
                destinationFile.writeAsBytesSync(content);

                print('Archivo copiado exitosamente de $sourceFile a $destinationFile');

                ScaffoldMessenger.of(context).showSnackBar(
                  Widgets.snackBar("success", 'Archivo "bk_connection $fechaHora.json" copiado exitosamente.'),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "1",
                child: Text('Importar conexiones'),
              ),
              const PopupMenuItem<String>(
                value: "2",
                child: Text('Exportar conexiones'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
