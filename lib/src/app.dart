import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/screens/home_screen.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Tutor App',
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}