import 'package:final_devmobile/database/database_helper.dart';
import 'package:final_devmobile/models/lista_compra_model.dart';

class ListaCompraDao {
  static const String _tableName = 'lista_compra';

  /// Insere uma nova lista de compras
  static Future<int> insert(ListaCompra lista) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.insert(_tableName, lista.toMap());
  }

  /// Busca todas as listas de um usuário
  static Future<List<ListaCompra>> getAll(String usuarioId) async {
    final db = await DatabaseHelper.getDatabase();
    final maps = await db.query(
      _tableName,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'data_criacao DESC',
    );
    return maps.map((e) => ListaCompra.fromMap(e)).toList();
  }

  /// Atualiza uma lista de compras
  static Future<int> update(ListaCompra lista) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.update(
      _tableName,
      lista.toMap(),
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [lista.id, lista.usuarioId],
    );
  }

  /// Deleta uma lista de compras
  static Future<int> delete(int id, String usuarioId) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.delete(
      _tableName,
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [id, usuarioId],
    );
  }

  /// Associa um item à lista
  static Future<void> associarItem(int listaId, int itemId) async {
    final db = await DatabaseHelper.getDatabase();
    await db.insert('lista_item_compra', {
      'lista_id': listaId,
      'item_id': itemId,
    });
  }

  /// Busca uma lista de compras pelo id e usuarioId
  static Future<ListaCompra?> getListaCompraById(
    int id,
    String usuarioId,
  ) async {
    final db = await DatabaseHelper.getDatabase();
    final maps = await db.query(
      _tableName,
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [id, usuarioId],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return ListaCompra.fromMap(maps.first);
    }
    return null;
  }
}
