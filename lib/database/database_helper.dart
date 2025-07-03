import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'app_compras.db';
  static const _dbVersion = 2;

  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        // Habilita foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // Tabela de usuários
        await db.execute('''
          CREATE TABLE usuario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            phone TEXT,
            name TEXT,
            password TEXT
          );
        ''');

        // Tabela de categorias
        await db.execute('''
          CREATE TABLE categoria (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id)
          );
        ''');

        // Tabela de produtos
        await db.execute('''
          CREATE TABLE produto (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            categoria_id INTEGER,
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON DELETE SET NULL,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id)
          );
        ''');

        // Tabela de item_compra
        await db.execute('''
          CREATE TABLE item_compra (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            produto_id INTEGER NOT NULL,
            medida TEXT,
            quantidade REAL NOT NULL,
            preco REAL,
            comprado INTEGER NOT NULL DEFAULT 0,
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (produto_id) REFERENCES produto(id),
            FOREIGN KEY (usuario_id) REFERENCES usuario(id)
          );
        ''');

        // Tabela de lista_compra
        await db.execute('''
          CREATE TABLE lista_compra (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            data_criacao TEXT NOT NULL,
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id)
          );
        ''');

        // Tabela de associação lista <-> itens
        await db.execute('''
          CREATE TABLE lista_item_compra (
            lista_id INTEGER NOT NULL,
            item_id INTEGER NOT NULL,
            PRIMARY KEY (lista_id, item_id),
            FOREIGN KEY (lista_id) REFERENCES lista_compra(id),
            FOREIGN KEY (item_id) REFERENCES item_compra(id)
          );
        ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // tabela vazia: podemos dropar sem perda de dados:
          await db.execute('DROP TABLE IF EXISTS item_compra;');

          // recria com medida NOT NULL
          await db.execute('''
          CREATE TABLE item_compra (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            produto_id INTEGER NOT NULL,
            medida TEXT,
            quantidade REAL NOT NULL,
            preco REAL,
            comprado INTEGER NOT NULL DEFAULT 0,
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (produto_id) REFERENCES produto(id),
            FOREIGN KEY (usuario_id) REFERENCES usuario(id)
          );
        ''');
        }
      },
    );
  }
}
