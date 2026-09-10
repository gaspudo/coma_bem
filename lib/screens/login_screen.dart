import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../components/botao_customizado.dart';
import '../components/campo_formulario_customizado.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha e-mail e senha.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var usuario = await DatabaseHelper().autenticarUsuario(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return; // checar mounted ANTES de usar context após await

      if (usuario.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    } finally {
      // finally garante que o loading some mesmo se der exceção.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            CampoFormularioCustomizado(
              titulo: 'Email',
              controlador: _usernameController,
              tipoTeclado: TextInputType.emailAddress,
            ),
            CampoFormularioCustomizado(
              titulo: 'Senha',
              controlador: _passwordController,
              ocultarTexto: true,
            ),
            const SizedBox(height: 20),

            BotaoCustomizado(
              texto: 'Entrar',
              aoPressed: _fazerLogin,
              carregando: _isLoading,
              corFundo: const Color(0xFFB25329),
            ),
          ],
        ),
      ),
    );
  }
}