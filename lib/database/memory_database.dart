// lib/database/memory_database.dart
//
// SUBSTITUTO TEMPORÁRIO do DatabaseHelper para apresentação web.
// Mantém os dados em memória durante a sessão — funciona enquanto o navegador
// não for fechado ou recarregado, que é exatamente o que precisamos.
//
// COMO REVERTER DEPOIS:
// Basta trocar 'memory_database.dart' por 'database_helper.dart' nos imports.
// A API é idêntica propositalmente.

class MemoryDatabase {
  static final MemoryDatabase _instance = MemoryDatabase._interno();
  factory MemoryDatabase() => _instance;
  MemoryDatabase._interno();

  // Tabelas simuladas em memória
  final List<Map<String, dynamic>> _usuarios = [];
  final List<Map<String, dynamic>> _restaurantes = [];

  int _proximoIdUsuario = 1;
  int _proximoIdRestaurante = 1;

  // ── AUTENTICAÇÃO ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> autenticarUsuario(
      String email, String senha) async {
    final resultado = _usuarios.where((u) =>
        u['usu_tx_email'] == email.toLowerCase() &&
        u['usu_tx_senha'] == senha);

    if (resultado.isNotEmpty) {
      return resultado.first;
    } else {
      throw Exception('Usuário não encontrado ou senha incorreta.');
    }
  }

  // ── INSERÇÃO GENÉRICA ───────────────────────────────────────────────────────

  Future<int> inserirDados(String tabela, Map<String, dynamic> dados) async {
    switch (tabela) {
      case 'usuario':
        // Verifica UNIQUE no email — mesmo comportamento do SQLite
        final emailExiste = _usuarios.any(
            (u) => u['usu_tx_email'] == dados['usu_tx_email']);
        if (emailExiste) {
          throw Exception('UNIQUE constraint failed: usuario.usu_tx_email');
        }
        final novoUsuario = {
          'usu_id_usuario': _proximoIdUsuario++,
          ...dados,
        };
        _usuarios.add(novoUsuario);
        return novoUsuario['usu_id_usuario'];

      case 'restaurante':
        final novoRestaurante = {
          'res_id_restaurante': _proximoIdRestaurante++,
          ...dados,
        };
        _restaurantes.add(novoRestaurante);
        return novoRestaurante['res_id_restaurante'];

      default:
        throw Exception('Tabela "$tabela" não existe no MemoryDatabase.');
    }
  }

  // ── CONSULTAS ───────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> consultarDados(String tabela) async {
    switch (tabela) {
      case 'usuario':
        return List.from(_usuarios);
      case 'restaurante':
        return List.from(_restaurantes);
      default:
        return [];
    }
  }

  Future<List<Map<String, dynamic>>> listarRestaurantesPorTipo(
      String tipo) async {
    return _restaurantes
        .where((r) => r['res_ds_tipo_culinaria'] == tipo)
        .toList();
  }

  Future<List<Map<String, dynamic>>> buscarRestaurantePorNome(
      String termoBusca) async {
    return _restaurantes
        .where((r) => r['res_nm_restaurante']
            .toString()
            .toLowerCase()
            .contains(termoBusca.toLowerCase()))
        .toList();
  }
}