import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import '../database/memory_database.dart';
import '../components/botao_customizado.dart';
import '../components/campo_formulario_customizado.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culinariaController = TextEditingController();
  final TextEditingController _rankingController = TextEditingController();
  final TextEditingController _pratoController = TextEditingController();

  File? _fotoPrato;
  String _latitude = '';
  String _longitude = '';
  final bool _isLoading = false;
  bool _isLoadingLocalizacao = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nomeController.dispose();
    _culinariaController.dispose();
    // LIBERAÇÃO DE MEMÓRIA: Adicionados os disposes ausentes
    _rankingController.dispose();
    _pratoController.dispose();
    super.dispose();
  }

  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada =
        await _picker.pickImage(source: ImageSource.camera);
    if (fotoCapturada != null) {
      setState(() => _fotoPrato = File(fotoCapturada.path));
    }
  }

  Future<void> _pegarLocalizacao() async {
    setState(() => _isLoadingLocalizacao = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
        _isLoadingLocalizacao = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localização obtida com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingLocalizacao = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter localização: $e')),
      );
    }
  }

  void _salvarCadastro() async {
    if (_nomeController.text.isEmpty || _culinariaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha os campos obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int? ranking = int.tryParse(_rankingController.text);

    if (ranking == null || ranking < 1 || ranking > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O Ranking deve ser uma nota de 1 a 5!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // CORREÇÃO: Variáveis da classe usavam _latitude e _longitude
    Map<String, dynamic> dadosRestaurante = {
      'res_nm_restaurante': _nomeController.text,
      'res_ds_tipo_culinaria': _culinariaController.text,
      'res_ds_prato': _pratoController.text,
      'res_nu_latitude': _latitude,
      'res_nu_longitude': _longitude,
      'res_nu_ranking': ranking,
    };

    try {
      await MemoryDatabase().inserirDados('restaurante', dadosRestaurante);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurante cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (erro) {
      print('DEBUG Erro ao salvar no SQLite: $erro');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro inesperado ao salvar.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Restaurante'),
        backgroundColor: const Color(0xFFEBE5DF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CampoFormularioCustomizado(
              titulo: 'Nome do Restaurante',
              controlador: _nomeController,
            ),
            CampoFormularioCustomizado(
              titulo: 'Tipo de Culinária',
              controlador: _culinariaController,
            ),
            // INCLUSÃO DOS CAMPOS SOLICITADOS NO FORMULÁRIO
            CampoFormularioCustomizado(
              titulo: 'Nome do Prato Principal',
              controlador: _pratoController,
            ),
            CampoFormularioCustomizado(
              titulo: 'Ranking (Nota de 1 a 5)',
              controlador: _rankingController,
            ),

            const SizedBox(height: 20),

            const Text(
              'Foto do Prato',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _fotoPrato != null
                    ? Image.file(_fotoPrato!, fit: BoxFit.cover)
                    : const Center(child: Text('Nenhuma foto selecionada')),
              ),
            ),
            const SizedBox(height: 10),

            BotaoCustomizado(
              texto: 'Tirar Foto do Prato',
              aoPressed: _tirarFoto,
              corFundo: const Color(0xFFB25329),
            ),
            const SizedBox(height: 12),
            BotaoCustomizado(
              texto: 'Obter Localização',
              aoPressed: _pegarLocalizacao,
              carregando: _isLoadingLocalizacao,  
              corFundo: const Color(0xFFB25329),
            ),

            if (_latitude.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Lat: $_latitude\nLng: $_longitude',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 30),

            BotaoCustomizado(
              texto: 'Salvar Cadastro',
              aoPressed: _salvarCadastro,
              carregando: _isLoading,
              corFundo: const Color(0xFFB25329),
            ),
          ],
        ),
      ),
    );
  }
}