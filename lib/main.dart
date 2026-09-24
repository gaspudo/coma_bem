import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/login_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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