import 'package:flutter/material.dart';

Widget buildSimpleDataTable({
  required BuildContext context,
  required List<Map<String, dynamic>> data,
  bool fillSize = false,
}) {
  if (data.isEmpty) {
    return const Center(child: Text("No data available"));
  }

  final columns = data.first.keys.toList();

  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: fillSize
          ? ConstrainedBox(
              constraints: BoxConstraints.expand(
                width: MediaQuery.of(context).size.width,
              ),
              child: DataTable(
                columns: columns
                    .map((col) => DataColumn(label: Text(col)))
                    .toList(),
                rows: data.map((row) {
                  return DataRow(
                    cells: columns.map((col) {
                      return DataCell(Text(row[col].toString()));
                    }).toList(),
                  );
                }).toList(),
              ),
            )
          : DataTable(
              // ignore: deprecated_member_use
              dataRowHeight: 40,
              columns: columns
                  .map((col) => DataColumn(label: Text(col)))
                  .toList(),
              rows: data.map((row) {
                return DataRow(
                  cells: columns.map((col) {
                    return DataCell(Text(row[col].toString()));
                  }).toList(),
                );
              }).toList(),
            ),
    ),
  );
}

