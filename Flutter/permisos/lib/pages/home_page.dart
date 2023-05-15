import 'package:flutter/material.dart';
import 'package:permisos/pages/home_app_bar.dart';
import 'package:permisos/pages/scripts.dart';

import 'home_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      body: ListView(
        children: [
          HomeAppBar(),
          Container(
            height: 500,
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
                ScriptApp(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
