import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

/// Classe responsável por gerenciar o banco de dados SQLite
/// e realizar as transaçoes de autenticacao, insercao, cadastro, alteracao e delete

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._interno();
  factory DatabaseHelper() => _instance;

  static Database? _bancoDeDados;

  DatabaseHelper._interno();

  /// inicia conexao com o database
  Future<Database> get bancoDeDados async {
    if (_bancoDeDados != null) return _bancoDeDados!;
    _bancoDeDados = await _iniciarBanco();
    return _bancoDeDados!;
  }

  /// configura o caminho do banco de dados e cria as tabelas caso nao existam
  Future<Database> _iniciarBanco() async {
    String caminhoBanco = await getDatabasesPath();
    String caminhoCompleto = join(caminhoBanco, "comabem.db");
    return await openDatabase(caminhoCompleto, version: 1, onCreate: _criarTabelas);
  }

  Future<void> _criarTabelas(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS usuario (
        usu_id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        usu_nm_usuario TEXT NOT NULL,
        usu_tx_email TEXT NOT NULL UNIQUE,
        usu_tx_senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS restaurante (
        res_id_restaurante INTEGER PRIMARY KEY AUTOINCREMENT,
        res_nm_restaurante TEXT NOT NULL,
        res_nu_latitude REAL NOT NULL,
        res_nu_longitude REAL NOT NULL,
        res_ds_tipo_culinaria TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS prato (
        pra_id_prato INTEGER PRIMARY KEY AUTOINCREMENT,
        pra_nm_prato TEXT NOT NULL,
        pra_im_foto TEXT NULL,
        pra_id_restaurante INTEGER NOT NULL,

        FOREIGN KEY (pra_id_restaurante) REFERENCES restaurante(res_id_restaurante)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS avaliacao (
        avl_id_avaliacao INTEGER PRIMARY KEY AUTOINCREMENT,
        avl_nu_ranking INTEGER NOT NULL CHECK(avl_nu_ranking >= 1 AND avl_nu_ranking <= 5),
        avl_tx_recomendacao TEXT,
        avl_id_usuario INTEGER NOT NULL,
        avl_id_prato INTEGER NOT NULL,
        FOREIGN KEY (avl_id_usuario) REFERENCES usuario(usu_id_usuario),
        FOREIGN KEY (avl_id_prato) REFERENCES prato(pra_id_prato)
      )
    ''');
  }

  // ========================================================
  // TRANSACOES DE MANIPULACAO DE DADOS E AUTENTICACAO
  // ========================================================

  /// Realiza a autenticação do usuário no banco de dados, verificando se o email e a senha fornecidos correspondem a um registro existente na tabela "usuario". 

  Future<Map<String, dynamic>> autenticarUsuario(String email, String senha) async {
    Database db = await bancoDeDados;
    List<Map<String, dynamic>> resultado = await db.query(
      'usuario',
      where: 'usu_tx_email = ? AND usu_tx_senha = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isNotEmpty) {
      return resultado.first;
    } else {
      throw Exception('Usuário não encontrado ou senha incorreta.');
    }
  }

  /// Realiza a inserção de um novo registro.
  Future<int> inserirDados(String tabela, Map<String, dynamic> dados) async {
    Database db = await bancoDeDados;
    return await db.insert(tabela, dados);
  }

  /// Realiza a consulta de registros
  Future<List<Map<String, dynamic>>> consultarDados(String tabela) async {
    Database db = await bancoDeDados;
    return await db.query(tabela);
  }

  /// Realiza a atualização de um registro existente.
  Future<int> alterarDados(String tabela, Map<String, dynamic> novosDados, String colunaId, int id) async {
    Database db = await bancoDeDados;
    return await db.update(
      tabela,
      novosDados,
      where: '$colunaId = ?',
      whereArgs: [id]);
  }

  /// Realiza a exclusão de um registro existente.
  Future<int> excluirDados (String tabela, String colunaId, int id) async {
    Database db = await bancoDeDados;
    return await db.delete(
      tabela,
      where: '$colunaId = ?',
      whereArgs: [id]);
  }
}