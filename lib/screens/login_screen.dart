import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../components/botao_customizado.dart';
import '../components/campo_formulario_customizado.dart';
import '../utils/hash_util.dart';
import 'home_screen.dart';
import 'usuario_cadastro_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (_emailController.text.trim().isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha e-mail e senha.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {

      final usuario = await DatabaseHelper().autenticarUsuario(
        _emailController.text.trim().toLowerCase(),
        hashSenha(_senhaController.text),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  HomeScreen()),
      );
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha inválidos.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Faça login para continuar',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            CampoFormularioCustomizado(
              titulo: 'E-mail',
              controlador: _emailController,
              tipoTeclado: TextInputType.emailAddress,
            ),
            CampoFormularioCustomizado(
              titulo: 'Senha',
              controlador: _senhaController,
              ocultarTexto: true,
            ),

            const SizedBox(height: 24),

            BotaoCustomizado(
              texto: 'Entrar',
              aoPressed: _fazerLogin,
              carregando: _isLoading,
              corFundo: const Color(0xFFB25329),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CadastroUsuarioScreen()),
              ),
              child: const Text(
                'Não tem conta? Cadastre-se',
                style: TextStyle(color: Color(0xFFB25329)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}