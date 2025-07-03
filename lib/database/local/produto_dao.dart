import 'package:final_devmobile/database/database_helper.dart';
import 'package:final_devmobile/models/produto_model.dart';
import 'package:sqflite/sqflite.dart';

class ProdutoDao {
  static const String _tableName = 'produto';

  /// Insere um novo produto
  static Future<Produto> insertProduto(Produto prod) async {
    final db = await DatabaseHelper.getDatabase();
    final prodMap = prod.toMap();

    try {
      final id = await db.insert(
        _tableName,
        prodMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return prod.copyWith(id: id);
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Já existe um produto com este código.');
      } else {
        throw Exception('Erro ao salvar produto.');
      }
    }
  }

  /// Retorna todos os produtos de um usuário
  static Future<List<Produto>> getAllProduto(int usuarioId) async {
    final db = await DatabaseHelper.getDatabase();
    final maps = await db.query(
      _tableName,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return List.generate(maps.length, (i) => Produto.fromMap(maps[i]));
  }

  /// Deleta um produto pelo ID
  static Future<int> deleteProdutoById(int id, int usuarioId) async {
    try {
      final db = await DatabaseHelper.getDatabase();
      return await db.delete(
        _tableName,
        where: 'id = ? AND usuario_id = ?',
        whereArgs: [id, usuarioId],
      );
    } catch (e) {
      return 0;
    }
  }

  /// Retorna um produto pelo ID e usuarioId
  static Future<Produto?> getProdutoById(int id, int usuarioId) async {
    final db = await DatabaseHelper.getDatabase();
    final maps = await db.query(
      _tableName,
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [id, usuarioId],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Produto.fromMap(maps.first);
    }
    return null;
  }
}
