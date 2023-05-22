import 'package:flutter/material.dart';
import 'package:permisos/view/script/list_script.dart';
import 'connection/list_conn.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF4C53A5),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 25),
              child: const Text(
                'RemoteDB',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            title: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AppConection(),
                  ),
                );
              },
              child: const Text(
                'Conexiones',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4C53A5)),
              ),
            ),
            onTap: () {
              // Update the state of the app.
            },
          ),
          ListTile(
            title: const Text(
              'Scripts',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4C53A5)),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const AppScript(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
