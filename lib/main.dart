import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ComaBemApp());
}

class ComaBemApp extends StatelessWidget {
  const ComaBemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coma Bem',
      debugShowCheckedModeBanner: false, // remove a faixa "DEBUG" no canto
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB25329),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}