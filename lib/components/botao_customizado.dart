import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {


  final String texto;
  final VoidCallback? aoPressed; // nullable: permite botão desabilitado nativamente

  final Color corFundo;
  final Color corTexto;
  final double largura; // double.infinity = ocupa toda a largura disponível
  final bool carregando; // exibe spinner quando true — essencial em UX real

  const BotaoCustomizado({
    super.key, // boa prática: sempre repasse a key ao super
    required this.texto,
    required this.aoPressed,
    this.corFundo = const Color(0xFFFF6B00), // laranja — ajuste pela sua paleta Figma
    this.corTexto = Colors.white,
    this.largura = double.infinity,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: largura,

      child: ElevatedButton(
        onPressed: carregando ? null : aoPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo,
          foregroundColor: corTexto, // afeta texto E ícone filho
          disabledBackgroundColor: corFundo.withOpacity(0.5),

          padding: const EdgeInsets.symmetric(vertical: 16.0),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),

          elevation: 2,

          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,

          ),
        ),

        // child condicional: texto normal ou indicador de progresso
        child: carregando
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: corTexto,
                ),
              )
            : Text(texto),
      ),
    );
  }
}
