import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/formate_datetime.dart';

class SqliteHelper {
  // Singleton
  static final SqliteHelper _instance = SqliteHelper._internal();
  factory SqliteHelper() => _instance;
  SqliteHelper._internal();

  static Database? _db;

  // Increment version if you add new tables or change schema
  static const int _dbVersion = 2;

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_local_db.db');
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreateDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  static Future<void> _onCreateDB(Database db, int version) async {
    // Create all tables from scratch
    await db.execute('''
      CREATE TABLE category(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE product(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        category_id INTEGER,
        FOREIGN KEY (category_id) REFERENCES category(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE product_image(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        image_url TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES product(id)
      )
    ''');
  }

  // Handle migrations for existing DB
  static Future<void> _onUpgradeDB(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // Add product_image table if missing
      await db.execute('''
        CREATE TABLE IF NOT EXISTS product_image(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER,
          image_url TEXT NOT NULL,
          FOREIGN KEY (product_id) REFERENCES product(id)
        )
      ''');
    }
  }

  /// Insert sample data
  Future<void> insertSampleData() async {
    final db = await SqliteHelper.database;

    int electronicsId = await db.insert('category', {'name': 'Electronics'});
    int fashionId = await db.insert('category', {'name': 'Fashion'});

    int phoneId = await db.insert('product', {
      'name': 'Smartphone',
      'price': 699.99,
      'category_id': electronicsId,
    });
    int tshirtId = await db.insert('product', {
      'name': 'T-Shirt',
      'price': 19.99,
      'category_id': fashionId,
    });

    await db.insert('product_image', {
      'product_id': phoneId,
      'image_url': 'https://example.com/phone.png',
    });
    await db.insert('product_image', {
      'product_id': tshirtId,
      'image_url': 'https://example.com/tshirt.png',
    });

    debugPrint('✅ Sample data inserted');
  }

  /// Export DB to backup file
  static Future<bool> exportToBackupFile() async {
    try {
      final now = DateTime.now();
      final formattedDate = DateFormatter.format(now, 'dd-MM-yyyy');

      final dbPath = await getDatabasesPath();
      final originalPath = join(dbPath, 'app_local_db.db');

      String backupPath;

      if (Platform.isAndroid) {
        if (!await _requestPermission()) return false;
        const downloadsPath = '/storage/emulated/0/Download';
        backupPath = join(
          downloadsPath,
          '${formattedDate}_backup_app_local_db.db',
        );
      } else {
        backupPath = join(dbPath, '${formattedDate}_backup_app_local_db.db');
      }

      await File(originalPath).copy(backupPath);
      debugPrint('✅ Backup successful: $backupPath');
      return true;
    } catch (e, stack) {
      debugPrint('❌ Export failed: $e\n$stack');
      return false;
    }
  }

  /// Request storage permissions
  static Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) return true;

      final status = await Permission.storage.request();
      if (status.isGranted) return true;

      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      return false;
    }
    return true; // iOS doesn't need permission
  }

  /// Close DB
  static Future<void> closeDB() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  /// Import DB from picked file
  static Future<bool> importFromPickedFile(String pickedFilePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final destPath = join(dbPath, 'app_local_db.db');

      final pickedFile = File(pickedFilePath);
      if (!await pickedFile.exists()) return false;

      await closeDB();
      await pickedFile.copy(destPath);

      await database; // reopen DB
      debugPrint('✅ Import successful');
      return true;
    } catch (e, stack) {
      debugPrint('❌ Import failed: $e\n$stack');
      return false;
    }
  }
}
