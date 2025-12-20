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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC9A25B),
          primary: const Color(0xFFC9A25B),
        ),
      ),
      home: MyHomePage(),
    );
  }
}