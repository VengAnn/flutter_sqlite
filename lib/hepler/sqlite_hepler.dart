import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHepler {
  // Singleton pattern to ensure only one instance of the database helper
  static final SqliteHepler _instance = SqliteHepler._internal();
  factory SqliteHepler() => _instance;
  SqliteHepler._internal();

  static Database? _db;

  Future<Database> get database async {
    return _db ?? await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_local_db.db');

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future<void> _onCreateDB(Database db, int version) async {
    // table category
    await db.execute('''
      CREATE TABLE category(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // table product
    await db.execute('''
      CREATE TABLE product(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        category_id INTEGER,
        FOREIGN KEY (category_id) REFERENCES category(id)
      )
    ''');

    // product image table
    await db.execute('''
      CREATE TABLE product_image(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        image_url TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES product(id)
      )
    ''');
  }

  // Reset the database tables
  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS product_image');
    await db.execute('DROP TABLE IF EXISTS product');
    await db.execute('DROP TABLE IF EXISTS category');
    await _onCreateDB(db, 1);

    debugPrint('Database tables reset and recreated.');
  }

  // Delete the database file
  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_local_db.db');

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      _db = null;
      debugPrint('Database file deleted: $path');
    } else {
      debugPrint('Database file not found at: $path');
    }
  }

  // Close the database connection
  static Future<void> closeDB() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      debugPrint('Database connection closed.');
    }
  }

  static Future<void> exportDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'app_local_db.db'));

      // Export path: for example, app documents directory manually specified on Android/iOS
      final exportPath = join(dbPath, 'backup_app_local_db.db');
      final exportFile = File(exportPath);

      await exportFile.writeAsBytes(await dbFile.readAsBytes());

      debugPrint('Database exported to: $exportPath');
    } catch (e) {
      debugPrint('Export failed: $e');
    }
  }

  static Future<void> importDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final originalDbFile = File(join(dbPath, 'app_local_db.db'));

      // This is the backup file path you exported before
      final backupFile = File(join(dbPath, 'backup_app_local_db.db'));

      if (await backupFile.exists()) {
        await originalDbFile.writeAsBytes(
          await backupFile.readAsBytes(),
          flush: true,
        );
        debugPrint('Database imported from: ${backupFile.path}');
      } else {
        debugPrint('Backup file not found at: ${backupFile.path}');
      }
    } catch (e) {
      debugPrint('Import failed: $e');
    }
  }
}
