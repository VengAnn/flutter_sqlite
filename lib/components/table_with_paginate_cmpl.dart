import 'package:flutter/material.dart';

class PaginatedDataTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int rowsPerPage;
  final String? title;

  const PaginatedDataTableWidget({
    super.key,
    required this.data,
    this.rowsPerPage = 5,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final columns = data.first.keys.toList();

    return SingleChildScrollView(
      child: PaginatedDataTable(
        header: title != null ? Text(title!) : null,
        columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
        source: _DataSource(data: data, columns: columns),
        rowsPerPage: rowsPerPage,
        columnSpacing: 20,
        showCheckboxColumn: false,
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final List<String> columns;

  _DataSource({required this.data, required this.columns});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;

    final row = data[index];

    return DataRow.byIndex(
      index: index,
      cells: columns.map((col) => DataCell(Text(row[col].toString()))).toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
