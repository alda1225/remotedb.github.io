import 'package:flutter/material.dart';
import 'package:permisos/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        "/": (context) => HomePage(),
      },

      //home: MyHomePage(),
    );
  }
}
