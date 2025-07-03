import 'package:final_devmobile/database/database_helper.dart';
import 'package:final_devmobile/models/categoria_model.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaDao {
  static const String _tableName = 'categoria';

  static Future<Categoria> insertCategoria(Categoria cat) async {
    final db = await DatabaseHelper.getDatabase();
    final catMap = cat.toMap();
    try {
      final id = await db.insert(
        _tableName,
        catMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return cat.copyWith(id: id);
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Já existe uma categoria com este id.');
      } else {
        throw Exception('Erro ao salvar categoria.');
      }
    }
  }

  static Future<List<Categoria>> getAllCategoriaByUsuarioId(
    int usuarioId,
  ) async {
    final db = await DatabaseHelper.getDatabase();
    final maps = await db.query(
      _tableName,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return List.generate(maps.length, (i) => Categoria.fromMap(maps[i]));
  }

  static Future<int> deleteCategoriaById(int id, int usuarioId) async {
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

  static Future<void> updateCategoriaById(
    int id,
    String nome,
    int usuarioId,
  ) async {
    final db = await DatabaseHelper.getDatabase();

    final count = await db.update(
      _tableName,
      {'nome': nome},
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [id, usuarioId],
    );

    if (count == 0) {
      throw Exception(
        'Nenhuma categoria encontrada com este Id para esse usuário.',
      );
    }
  }
}
