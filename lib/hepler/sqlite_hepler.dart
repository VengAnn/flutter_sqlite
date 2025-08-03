import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/formate_datetime.dart';

class SqliteHepler {
  // Singleton pattern to ensure only one instance of the database helper
  static final SqliteHepler _instance = SqliteHepler._internal();
  factory SqliteHepler() => _instance;
  SqliteHepler._internal();

  static Database? _db;

  static Future<Database> get database async {
    return _db ?? await _initDB();
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_local_db.db');

    // debugPrint('Database path: $path');
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  static Future<void> _onCreateDB(Database db, int version) async {
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
  static Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS product_image');
    await db.execute('DROP TABLE IF EXISTS product');
    await db.execute('DROP TABLE IF EXISTS category');
    await _onCreateDB(db, 1);
    debugPrint('Database reset successfully.');
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

  // static Future<bool> exportToBackupFile() async {
  //   try {
  //     final now = DateTime.now();
  //     final formattedDate = DateFormatter.format(now, 'dd-MM-yyyy');

  //     final dbPath = await getDatabasesPath();
  //     final originalPath = '$dbPath/app_local_db.db';
  //     final backupPath = '$dbPath/${formattedDate}_backup_app_local_db.db';

  //     await File(originalPath).copy(backupPath);
  //     debugPrint('Database backup created at: $backupPath');

  //     return true;
  //   } catch (e) {
  //     debugPrint('Export failed: $e');
  //     return false;
  //   }
  // }
  static Future<bool> exportToBackupFile() async {
    try {
      final now = DateTime.now();
      final formattedDate = DateFormatter.format(now, 'dd-MM-yyyy');

      // Original DB path
      final dbPath = await getDatabasesPath();
      final originalPath = '$dbPath/app_local_db.db';

      late String backupPath;

      if (Platform.isAndroid) {
        debugPrint('Platform is Android');

        // Download folder path (hardcoded)
        const downloadsPath = '/storage/emulated/0/Download';
        final backupFileName = '${formattedDate}_backup_app_local_db.db';
        backupPath = '$downloadsPath/$backupFileName';
      } else if (Platform.isIOS) {
        debugPrint('Platform is iOS');

        backupPath = '$dbPath/${formattedDate}_backup_app_local_db.db';
      }

      await File(originalPath).copy(backupPath);
      debugPrint('✅ Backup successful: $backupPath');

      return true;
    } catch (e) {
      debugPrint('❌ Export failed: $e');

      return false;
    }
  }

  /// Replace DB using manually picked file
  static Future<bool> importFromPickedFile(String pickedFilePath) async {
    try {
      // Get the path where the app's database is stored on the device
      final dbPath = await getDatabasesPath();

      // Define the destination path where the database should be replaced
      final destPath = '$dbPath/app_local_db.db';

      // Check if the picked file actually exists
      if (!await File(pickedFilePath).exists()) return false;

      // Close the current open database connection to avoid file lock issues
      await closeDB();

      // Copy the picked file to replace the current database
      await File(pickedFilePath).copy(destPath);

      // Re-initialize or reopen the database connection
      await database;

      return true;
    } catch (e) {
      debugPrint('Import from picked file failed: $e');

      return false;
    }
  }
}
