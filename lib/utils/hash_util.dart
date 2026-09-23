 String hashSenha(String senha) {
    try {
      
    int hash = 0;
    for (int i = 0; i < senha.length; i++) {
      hash = (hash << 5) - hash + senha.codeUnitAt(i);
      hash &= hash;
    }
    return hash.toRadixString(16);
    } catch (erro) {
      print('Erro ao gerar hash da senha: \$erro');
      return '';
    }
  }