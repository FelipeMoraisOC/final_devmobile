import 'package:final_devmobile/database/database_constants.dart';
import 'package:final_devmobile/models/user_model.dart';
import 'package:final_devmobile/shared/utils/encrypt.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class UserDao {
  static const String _dbName = DatabaseConstants.dbName;
  static const String _tableName = 'usuario';

  static Future _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        phone TEXT,
        name TEXT,
        password TEXT        
        )
        ''');
      },
    );
  }

  static Future<void> deleteAllUsers() async {
    final db = await _getDatabase();
    await db.delete(_tableName);
  }

  static Future<UserModel> insertUser(UserModel user) async {
    final db = await _getDatabase();
    final userMap = user.toMap();
    userMap['password'] = Encrypt.encryptPassword(user.password!);
    try {
      final id = await db.insert(
        _tableName,
        userMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      // Retorna o UserModel com o id gerado
      return user.copyWith(id: id.toString());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Já existe um usuário com este e-mail.');
      } else {
        throw Exception('Erro ao salvar usuário.');
      }
    }
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUsers() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  static Future<int> deleteUserById(int id) async {
    try {
      final db = await _getDatabase();
      await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
