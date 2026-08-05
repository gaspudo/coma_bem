class Restaurante {
  int _idRestaurante;
  String _nomeRestaurante;
  String _latidude;
  String _longitude;
  String _tipoCulinaria;

  Restaurante(this._idRestaurante, this._nomeRestaurante, this._latidude,
      this._longitude, this._tipoCulinaria);

  int get idRestaurante => _idRestaurante;
  String get nomeRestaurante => _nomeRestaurante;
  String get latidude => _latidude;
  String get longitude => _longitude;
  String get tipoCulinaria => _tipoCulinaria;

  set nomeRestaurante(String nomeRestaurante) {
    _nomeRestaurante = nomeRestaurante;
  }

  set latidude(String latidude) {
    _latidude = latidude;
  }

  set longitude(String longitude) {
    _longitude = longitude;
  }

  set tipoCulinaria(String tipoCulinaria) {
    _tipoCulinaria = tipoCulinaria;
  }

  void exibirCategoriaCulinaria() {
    switch (_tipoCulinaria.toLowerCase()) {
      case 'japonesa':
        print("Categoria: Culinária Asiática - Foco em peixes e arroz.");
        break;
      case 'italiana':
        print("Categoria: Massas e Pizzas artesanais.");
        break;
      case 'brasileira':
        print("Categoria: Churrasco, Feijoada e pratos típicos.");
        break;
      default:
        print("Categoria: Culinária Internacional ou Diversa");
    }
  }
}
