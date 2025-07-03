import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'app_compras.db';
  static const _dbVersion = 3;

  /// Retorna o database, criándolo ou atualizándolo conforme necessário
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        // Ativa suporte a chaves estrangeiras e ON DELETE CASCADE
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Drop das tabelas que mudaram de esquema
          await db.execute('DROP TABLE IF EXISTS lista_item_compra;');
          await db.execute('DROP TABLE IF EXISTS item_compra;');
          await db.execute('DROP TABLE IF EXISTS lista_compra;');
          // Recria tudo
          await _onCreate(db, newVersion);
        }
      },
    );
  }

  /// Cria todas as tabelas com ON DELETE CASCADE onde for relevante
  static Future<void> _onCreate(Database db, int version) async {
    // Usuário
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        phone TEXT,
        name TEXT,
        password TEXT
      );
    ''');

    // Categoria
    await db.execute('''
      CREATE TABLE categoria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        usuario_id INTEGER NOT NULL,
        FOREIGN KEY (usuario_id)
          REFERENCES usuario(id)
          ON DELETE CASCADE
      );
    ''');

    // Produto
    await db.execute('''
      CREATE TABLE produto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        categoria_id INTEGER,
        usuario_id INTEGER NOT NULL,
        FOREIGN KEY (categoria_id)
          REFERENCES categoria(id)
          ON DELETE SET NULL,
        FOREIGN KEY (usuario_id)
          REFERENCES usuario(id)
          ON DELETE CASCADE
      );
    ''');

    // Item de Compra
    await db.execute('''
      CREATE TABLE item_compra (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto_id INTEGER NOT NULL,
        medida TEXT,
        quantidade REAL NOT NULL,
        preco REAL,
        comprado INTEGER NOT NULL DEFAULT 0,
        usuario_id INTEGER NOT NULL,
        FOREIGN KEY (produto_id)
          REFERENCES produto(id)
          ON DELETE CASCADE,
        FOREIGN KEY (usuario_id)
          REFERENCES usuario(id)
          ON DELETE CASCADE
      );
    ''');

    // Lista de Compras
    await db.execute('''
      CREATE TABLE lista_compra (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        data_criacao TEXT NOT NULL,
        usuario_id INTEGER NOT NULL,
        FOREIGN KEY (usuario_id)
          REFERENCES usuario(id)
          ON DELETE CASCADE
      );
    ''');

    // Associação Lista <-> Item
    await db.execute('''
      CREATE TABLE lista_item_compra (
        lista_id INTEGER NOT NULL,
        item_id  INTEGER NOT NULL,
        PRIMARY KEY (lista_id, item_id),
        FOREIGN KEY (lista_id)
          REFERENCES lista_compra(id)
          ON DELETE CASCADE,
        FOREIGN KEY (item_id)
          REFERENCES item_compra(id)
          ON DELETE CASCADE
      );
    ''');
  }
}
