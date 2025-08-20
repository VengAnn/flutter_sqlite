import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// ------------------- DB Helper -------------------
class DBHelper {
  static Database? _db;

  static Future<Database> initDB() async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS dynamic_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            table_name TEXT,
            row_data TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<void> insertRow(
    String tableName,
    Map<String, dynamic> row,
  ) async {
    final db = await initDB();
    await db.insert('dynamic_table', {
      'table_name': tableName,
      'row_data': jsonEncode(row),
    });
  }

  static Future<List<Map<String, dynamic>>> getRows() async {
    final db = await initDB();
    final data = await db.query('dynamic_table');
    return data
        .map(
          (e) => {
            'table_name': e['table_name'],
            ...jsonDecode(e['row_data'] as String) as Map<String, dynamic>,
          },
        )
        .toList();
  }

  static Future<void> clearRows() async {
    final db = await initDB();
    await db.delete('dynamic_table');
  }
}

// ------------------- Import Logic -------------------
Future<void> importSQLiteTables(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.any);
  if (result == null) return;

  final dbPath = result.files.single.path!;
  if (!File(dbPath).existsSync()) return;

  final externalDB = await openDatabase(dbPath, readOnly: true);

  final tables = await externalDB.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
  );

  if (tables.isEmpty) {
    await externalDB.close();
    return;
  }

  // Show table selection dialog
  // ignore: use_build_context_synchronously
  final tablesToImport = await _showTableSelectionDialog(context, tables);
  if (tablesToImport.isEmpty) {
    await externalDB.close();
    return;
  }

  await DBHelper.clearRows();
  int totalRowsImported = 0;

  for (var tableName in tablesToImport) {
    final rows = await externalDB.query(tableName);
    for (var row in rows) {
      final stringRow = row.map(
        (key, value) => MapEntry(key, value?.toString()),
      );
      await DBHelper.insertRow(tableName, stringRow);
    }
    totalRowsImported += rows.length;
  }

  await externalDB.close();
  log("Imported $totalRowsImported rows from ${tablesToImport.join(', ')}");
}

// ------------------- Table Selection Dialog -------------------
Future<List<String>> _showTableSelectionDialog(
  BuildContext context,
  List<Map<String, dynamic>> tables,
) async {
  Map<String, bool> selectedTables = {
    for (var t in tables) t['name'] as String: false,
  };
  bool selectAll = false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text('Select tables to import'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              CheckboxListTile(
                value: selectAll,
                title: Text('Select All'),
                onChanged: (val) {
                  setState(() {
                    selectAll = val!;
                    selectedTables.updateAll((key, value) => val);
                  });
                },
              ),
              ...selectedTables.entries.map(
                (entry) => CheckboxListTile(
                  value: entry.value,
                  title: Text(entry.key),
                  onChanged: (val) {
                    setState(() {
                      selectedTables[entry.key] = val!;
                      selectAll = !selectedTables.values.contains(false);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Import'),
          ),
        ],
      ),
    ),
  );

  if (confirmed != true) return [];
  return selectedTables.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toList();
}

// ------------------- Dynamic Table Page -------------------
class DynamicTablePage extends StatefulWidget {
  const DynamicTablePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DynamicTablePageState createState() => _DynamicTablePageState();
}

class _DynamicTablePageState extends State<DynamicTablePage> {
  List<Map<String, dynamic>> rows = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadRows();
  }

  Future<void> loadRows() async {
    setState(() => loading = true);
    rows = await DBHelper.getRows();
    setState(() => loading = false);
  }

  Future<void> handleImport(BuildContext context) async {
    setState(() => loading = true);
    await importSQLiteTables(context);
    await loadRows();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final columns = rows.isNotEmpty ? rows.first.keys.toList() : <String>[];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Table'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.green,
              ),
              onPressed: loading ? null : () => handleImport(context),
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text(
                'Import SQLite Table(s)',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : rows.isEmpty
                  ? Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.grey.shade300,
                          ),
                          columns: columns
                              .map(
                                (c) => DataColumn(
                                  label: Text(
                                    c,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          rows: rows
                              .map(
                                (row) => DataRow(
                                  cells: columns
                                      .map(
                                        (c) => DataCell(
                                          Text(row[c]?.toString() ?? ''),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
