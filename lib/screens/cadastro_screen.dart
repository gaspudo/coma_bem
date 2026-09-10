import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import '../database/database_helper.dart';
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

  File? _fotoPrato;
  String _latitude = '';
  String _longitude = '';
  bool _isLoading = false;


  bool _isLoadingLocalizacao = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nomeController.dispose();
    _culinariaController.dispose();
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

  Future<void> _salvarCadastro() async {
    // Validação: campos obrigatórios
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome do restaurante.')),
      );
      return;
    }
    if (_latitude.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Obtenha a localização antes de salvar.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> dadosRestaurante = {
        'res_nm_restaurante': _nomeController.text.trim(),
        'res_nu_latitude': _latitude,
        'res_nu_longitude': _longitude,
        'res_ds_tipo_culinaria': _culinariaController.text.trim(),
      };

      await DatabaseHelper().inserirDados('restaurante', dadosRestaurante);

      // mounted check obrigatório após qualquer await antes de usar context.
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

            const SizedBox(height: 20),

            // Foto do prato
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