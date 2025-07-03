import 'package:final_devmobile/database/database_helper.dart';
import 'package:final_devmobile/models/item_compra_model.dart';

class ItemCompraDao {
  static const String _tableName = 'item_compra';

  /// Insere um novo item de compra
  static Future<int> insert(ItemCompra item) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.insert(_tableName, item.toMap());
  }

  /// Retorna todos os itens do usuário
  static Future<List<ItemCompra>> getAll(String usuarioId) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query(
      _tableName,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return result.map((e) => ItemCompra.fromMap(e)).toList();
  }

  /// Retorna todos os itens associados a uma lista de compras
  static Future<List<ItemCompra>> getByListaId(int listaId) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.rawQuery(
      '''
        SELECT ic.* FROM item_compra ic
        INNER JOIN lista_item_compra lic ON ic.id = lic.item_id
        WHERE lic.lista_id = ?
      ''',
      [listaId],
    );

    return result.map((e) => ItemCompra.fromMap(e)).toList();
  }

  /// Atualiza um item de compra
  static Future<int> update(ItemCompra item) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.update(
      _tableName,
      item.toMap(),
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [item.id, item.usuarioId],
    );
  }

  /// Remove um item de compra
  static Future<int> delete(int id, String usuarioId) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.delete(
      _tableName,
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [id, usuarioId],
    );
  }
}
