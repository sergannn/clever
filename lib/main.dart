import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';

void main() {
  runApp(const CleverApp());
}

class CleverApp extends StatelessWidget {
  const CleverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clever',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'FamiljenGrotesk',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const IntroScreen(),
    );
  }
}
