import 'package:flutter/material.dart';
import 'package:permisos/view/home_page.dart';
import 'view/connection/list_conn.dart';
import 'view/script/list_script.dart';

import 'package:sizer/sizer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DBQuery',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.deepPurple,
          ),
          //home: HomeScreen() ,
          routes: {
            "/": (context) => AppHomePage(),
          },
        );
      },

      //home: MyHomePage(),
    );
  }
}
