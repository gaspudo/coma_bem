import 'package:flutter/material.dart';

class CampoFormularioCustomizado extends StatelessWidget {
  final String titulo;
  final TextEditingController controlador;
  final TextInputType tipoTeclado;
  final bool ocultarTexto;

  const CampoFormularioCustomizado({
    super.key,
    required this.titulo,
    required this.controlador,
    this.tipoTeclado = TextInputType.text,
    this.ocultarTexto = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controlador,
        keyboardType: tipoTeclado,
        obscureText: ocultarTexto,
        decoration: InputDecoration(
          labelText: titulo,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFB25329), // cor do app
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}