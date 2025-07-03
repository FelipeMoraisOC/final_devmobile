import 'package:final_devmobile/database/database_helper.dart';
import 'package:final_devmobile/models/user_model.dart';
import 'package:final_devmobile/shared/utils/encrypt.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  static const String _tableName = 'usuario';

  /// Apaga todos os usuários (cuidado ao usar)
  static Future<void> deleteAllUsers() async {
    final db = await DatabaseHelper.getDatabase();
    await db.delete(_tableName);
  }

  /// Insere um novo usuário no banco
  static Future<UserModel> insertUser(UserModel user) async {
    final db = await DatabaseHelper.getDatabase();
    final userMap = user.toMap();
    userMap['password'] = Encrypt.encryptPassword(user.password!);

    try {
      final id = await db.insert(
        _tableName,
        userMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return user.copyWith(id: id.toString());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Já existe um usuário com este e-mail.');
      } else {
        throw Exception('Erro ao salvar usuário.');
      }
    }
  }

  /// Busca um usuário por e-mail
  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  /// Retorna todos os usuários
  static Future<List<UserModel>> getAllUsers() async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query(_tableName);
    return List.generate(result.length, (i) => UserModel.fromMap(result[i]));
  }

  /// Remove usuário por ID
  static Future<int> deleteUserById(int id) async {
    final db = await DatabaseHelper.getDatabase();
    try {
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      return 0;
    }
  }

  /// Atualiza a senha de um usuário pelo e-mail
  static Future<void> updatePasswordByEmail(
    String email,
    String novaSenha,
  ) async {
    final db = await DatabaseHelper.getDatabase();
    final senhaCriptografada = Encrypt.encryptPassword(novaSenha);

    final count = await db.update(
      _tableName,
      {'password': senhaCriptografada},
      where: 'email = ?',
      whereArgs: [email],
    );

    if (count == 0) {
      throw Exception('Nenhum usuário encontrado com este e-mail.');
    }
  }
}
