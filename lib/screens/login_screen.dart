import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _fazerLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    var usuario = await DatabaseHelper().autenticarUsuario(username, password);

    if (usuario.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário ou senha inválidos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding (
        padding: const EdgeInsets.all(20.0),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fazerLogin,
              child: Text('Entrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB25329)
              ),
            ),
          ]
        )
      )
    );
  }
}