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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'RemoteDB',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'V 1.1',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Conexiones',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4C53A5)),
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const AppConection(),
                ),
              );
            },
          ),
          ListTile(
            title: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Scripts',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4C53A5)),
              ),
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
