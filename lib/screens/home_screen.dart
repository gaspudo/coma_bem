import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _restaurantes = [];

  @override void initState() {
    super.initState();
    _carregarRestaurantes();
  }

  void _carregarRestaurantes() async {
    List<Map<String, dynamic>> restaurantes = await DatabaseHelper().consultarDados('restaurante');
    setState(() {
      _restaurantes = restaurantes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Restaurantes'), backgroundColor: const Color(0xFFEBE5DF),
      ),
      body: ListView.builder(
        itemCount: _restaurantes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            color: const Color(0xFFEBE5DF),
            child: ListTile(
              leading: Icon(Icons.restaurant, color: Colors.deepOrange),
              title: Text(_restaurantes[index]['res_nm_restaurante'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Culinária: ${_restaurantes[index]['res_ds_tipo_culinaria']}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroScreen()),
          ).then((_) {
            _carregarRestaurantes();
          });
        },
        child: const Icon(Icons.add),
        backgroundColor:const Color(0xFFB25329),
      ),
    );
  }
}  
