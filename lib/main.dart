import 'package:flutter/material.dart';
import 'package:ballistic/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ballistic',
      theme: ThemeData(
         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
 .copyWith(secondary: Colors.blueAccent[400]),
      ),
      home: MyHomePage(),
    );
  }
}