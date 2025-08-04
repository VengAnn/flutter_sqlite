import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/formate_datetime.dart';

class SqliteHelper {
  static final SqliteHelper _instance = SqliteHelper._internal();
  factory SqliteHelper() => _instance;
  SqliteHelper._internal();

  static Database? _db;
  static const String _dbName = 'app_local_db.db';

  /// Initialize database
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: 1);
  }

  /// Dynamic create table
  static Future<void> createTable(String tableName, String fields) async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        $fields
      )
    ''');
  }

  /// Execute Insert/Update/Delete (raw SQL)
  static Future<int> execute(String query, [List<Object?>? args]) async {
    final db = await database;
    return await db.rawInsert(query, args ?? []);
  }

  /// Execute Update
  static Future<int> update(String query, [List<Object?>? args]) async {
    final db = await database;
    return await db.rawUpdate(query, args ?? []);
  }

  /// Execute Delete
  static Future<int> delete(String query, [List<Object?>? args]) async {
    final db = await database;
    return await db.rawDelete(query, args ?? []);
  }

  /// Get data (select query)
  static Future<List<Map<String, dynamic>>> query(
    String query, [
    List<Object?>? args,
  ]) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(query, args);
    return List<Map<String, dynamic>>.from(maps); // mutable list
  }

  /// Check if table exists
  static Future<bool> tableExists(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  /// Export database
  static Future<bool> exportDbBackUp() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, _dbName));

      final now = DateTime.now();
      final formattedDate = DateFormatter.format(now, 'dd-MM-yyyy');
      final String fileName = '${formattedDate}_backup.db';

      late String backupPath;
      if (Platform.isAndroid) {
        const downloadsPath = '/storage/emulated/0/Download';
        backupPath = '$downloadsPath/$fileName';
      } else if (Platform.isIOS) {
        backupPath = '$dbPath/$fileName';
      }

      await dbFile.copy(backupPath);
      debugPrint('✅ Database exported to $backupPath');
      return true;
    } catch (e) {
      debugPrint('❌ Export failed: $e');
      return false;
    }
  }

  /// ✅ Import database
  static Future<bool> importDatabase(File importFile) async {
    try {
      final dbPath = await getDatabasesPath();
      final destination = File(join(dbPath, _dbName));

      await closeDb();
      await importFile.copy(destination.path);
      _db = await _initDB();

      debugPrint('Database imported successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Import failed: $e');
      return false;
    }
  }

  /// File picker to import DB
  static Future<bool> filePickerImport() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      return await importDatabase(File(result.files.single.path!));
    }
    return false;
  }

  /// Close database
  static Future<void> closeDb() async {
    if (_db != null) {
      try {
        await _db!.close();
      } catch (e) {
        debugPrint("❌ Error closing DB: $e");
      }
      _db = null;
    }
  }
}
