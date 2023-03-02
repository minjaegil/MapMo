import 'package:flutter/material.dart';
import 'package:mapmo/features/main_navigation/main_navigation_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: const Color.fromRGBO(157, 194, 9, 1.0),
          //colorSchemeSeed: Colors.green[700],
        ),
        home: const MainNavigationScreen());
  }
}
