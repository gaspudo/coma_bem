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
    if (ranking < 1 || ranking > 5) {
      throw ArgumentError('O ranking deve estar entre 1 e 5.');
    }
    _ranking = ranking;
  }

  set recomendacao(String recomendacao) {
    _recomendacao = recomendacao;
  }

}