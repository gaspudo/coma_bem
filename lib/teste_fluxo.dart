import 'models/restaurante.dart';

void main() {
  List<Restaurante> listaDeRestaurantes = [
    Restaurante(1, 'Sushi house', '-23.5', '-46.6', 'Japonesa'),
    Restaurante(2, 'Cantina Bella', "-24.6", '46.7', 'Italiana'),
    Restaurante(3, 'Costelão', '-23.7', '46.8', 'Brasileira')
  ];

  print("--- Catálogo de Restaurantes ---");

  for (Restaurante r in listaDeRestaurantes) {
    print ("Nome: ${r.nomeRestaurante} | Tipo: ${r.tipoCulinaria} ");
    
    r.exibirCategoriaCulinaria();
    print('-----------------------------');
  }
}