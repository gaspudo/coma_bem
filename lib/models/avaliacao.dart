class Avaliacao {
  int _idAvaliacao;
  int _ranking;
  String _recomendacao;
  int _idUsuario;
  int _idPrato;

  Avaliacao(this._idAvaliacao, this._ranking, this._recomendacao, this._idUsuario,
      this._idPrato);

  int get idAvaliacao => _idAvaliacao;
  int get ranking => _ranking;
  String get recomendacao => _recomendacao;
  int get idUsuario => _idUsuario;
  int get idPrato => _idPrato;

  set ranking(int ranking) {
    if (ranking >= 1 && ranking <= 5) {
      _ranking = ranking;
      print("Nota $ranking salva com sucesso!");
    } else if ( ranking > 5) {
      _ranking = 5;
      print("Aviso: A nota máxima permitida é 5.");
    } else {
      _ranking = 1;
      print("Aviso: A nota mínima permitida é 1.");
    }
  }

  set recomendacao(String recomendacao) {
    _recomendacao = recomendacao;
  }

}