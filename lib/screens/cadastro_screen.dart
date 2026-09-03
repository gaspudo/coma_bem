import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database/database_helper.dart';
import 'package:geolocator/geolocator.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culinariaController = TextEditingController();


  File? _fotoPrato;

  String _latitude = '';
  String _longitude = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada = await _picker.pickImage(source: ImageSource.camera);
    if (fotoCapturada != null) {
      setState(() {
        _fotoPrato = File(fotoCapturada.path);
      });
    }
  }

  void _salvarCadastro () async {
    Map<String, dynamic> dadosRestaurante = {
      'res_nm_restaurante': _nomeController.text,
      'res_nu_latitude': _latitude,
      'res_nu_longitude': _longitude,
      'res_ds_tipo_culinaria': _culinariaController.text,
    };

    await DatabaseHelper().inserirDados('restaurante', dadosRestaurante);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cadastro realizado com sucesso!')));
      Navigator.pop(context);
  }

  Future<void> _pegarLocalizacao() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });
      _salvarCadastro();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter localização: $e')),
      );
    }
   }


  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Restaurante'),
        backgroundColor: const Color(0xFFEBE5DF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Restaurante', border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _culinariaController,
              decoration: InputDecoration(labelText: 'Tipo de Culinária', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            
            Text('Foto do Prato', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

           Container (
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],

            child: _fotoPrato != null
                ? Image.file(_fotoPrato!, fit: BoxFit.cover)
                : Center(child: Text('Nenhuma foto selecionada')),
           ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _tirarFoto,
              icon: Icon(Icons.camera_alt),
              label: Text('Tirar Foto do prato'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB25329)),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _pegarLocalizacao,
              child: Text('Obter localização'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB25329)),
            ),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _salvarCadastro,
              child: Text('Salvar Cadastro'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB25329)),
            ),
          ),
          ],
        ),
      ),
    );
  }
}