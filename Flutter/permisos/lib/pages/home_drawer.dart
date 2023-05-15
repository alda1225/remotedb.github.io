import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Conexiones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4C53A5)),
            ),
            onTap: () {
              // Update the state of the app.
            },
          ),
          ListTile(
            title: const Text(
              'Scripts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4C53A5)),
            ),
            onTap: () {
              // Update the state of the app.
            },
          ),
        ],
      ),
    );
  }
}
