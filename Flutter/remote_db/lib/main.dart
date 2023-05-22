import 'package:flutter/material.dart';
import 'view/connection/list_conn.dart';
import 'view/script/list_script.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RemoteDB',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        "/": (context) => const AppScript(),
      },

      //home: MyHomePage(),
    );
  }
}
