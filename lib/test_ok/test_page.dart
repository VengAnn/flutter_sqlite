// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'sqlite_hepler.dart';

class TestExportPage extends StatefulWidget {
  const TestExportPage({super.key});

  @override
  State<TestExportPage> createState() => _TestExportPageState();
}

class _TestExportPageState extends State<TestExportPage> {
  bool isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite Export Test')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await SqliteHelper().insertSampleData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sample data inserted!')),
                );
              },
              child: const Text('Insert Sample Data'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isExporting
                  ? null
                  : () async {
                      setState(() => isExporting = true);
                      bool success = await SqliteHelper.exportToBackupFile();
                      setState(() => isExporting = false);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success ? 'Export successful!' : 'Export failed',
                          ),
                        ),
                      );
                    },
              child: isExporting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text('Export Database'),
            ),
          ],
        ),
      ),
    );
  }
}
