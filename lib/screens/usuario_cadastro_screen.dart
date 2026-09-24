import 'package:flutter/material.dart';
import '../database/memory_database.dart';
import '../components/botao_customizado.dart';
import '../components/campo_formulario_customizado.dart';
import 'login_screen.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  // Validações separadas em método próprio — não misture lógica de negócio
  // dentro do build() ou direto no onPressed. Separe responsabilidades.
  String? _validar() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    final confirmar = _confirmarSenhaController.text;

    if (nome.isEmpty) return 'Informe seu nome.';
    if (nome.length < 3) return 'Nome deve ter ao menos 3 caracteres.';

    if (email.isEmpty) return 'Informe seu e-mail.';
    // Regex mínima de e-mail: não é perfeita, mas pega os erros mais comuns.
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$').hasMatch(email)) {
      return 'E-mail inválido.';
    }

    if (senha.isEmpty) return 'Informe uma senha.';
    if (senha.length < 6) return 'Senha deve ter ao menos 6 caracteres.';

    if (confirmar != senha) return 'As senhas não coincidem.';

    return null; // null = tudo válido
  }

  Future<void> _cadastrar() async {
    // 1. Valida antes de qualquer operação assíncrona
    final erro = _validar();
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red.shade700),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dados = {
        'usu_nm_usuario': _nomeController.text.trim(),
        'usu_tx_email': _emailController.text.trim().toLowerCase(),
        'usu_tx_senha': (_senhaController.text),
      };

      // inserirDados já existe no MemoryDatabase — reutilizamos sem criar método novo.
      // DRY aplicado na camada de dados também, não só na UI.
      await MemoryDatabase().inserirDados('usuario', dados);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso! Faça login.'),
          backgroundColor: Colors.green,
        ),
      );

      // Vai para o login e remove esta tela da pilha de navegação.
      // pushReplacement: o botão "voltar" do celular não volta para o cadastro.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on Exception catch (e) {
      if (!mounted) return;

      print('Erro ao criar conta: ${e.toString()}');

      final mensagem = e.toString().contains('UNIQUE')
          ? 'Este e-mail já está cadastrado.'
          : 'Erro ao criar conta. Tente novamente.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        backgroundColor: const Color(0xFFEBE5DF),
        // leading null: o Flutter adiciona automaticamente o botão de voltar
        // porque há uma rota anterior na pilha de navegação.
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Bem-vindo ao Coma Bem!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Crie sua conta para começar',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ── COMPONENTES REUTILIZÁVEIS (DRY aplicado) ──────────────────
            CampoFormularioCustomizado(
              titulo: 'Nome completo',
              controlador: _nomeController,
            ),
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
            CampoFormularioCustomizado(
              titulo: 'Confirmar senha',
              controlador: _confirmarSenhaController,
              ocultarTexto: true,
            ),
            // ──────────────────────────────────────────────────────────────

            const SizedBox(height: 24),

            BotaoCustomizado(
              texto: 'Criar Conta',
              aoPressed: _cadastrar,
              carregando: _isLoading,
              corFundo: const Color(0xFFB25329),
            ),

            const SizedBox(height: 16),

            // Navegação para login — TextButton por ser ação secundária.
            // Usar BotaoCustomizado aqui seria peso visual desnecessário.
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text(
                'Já tem conta? Faça login',
                style: TextStyle(color: Color(0xFFB25329)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}