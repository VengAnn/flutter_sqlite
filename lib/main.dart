import 'package:flutter/material.dart';
import 'pages/dynamic_table_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SQLite',
      // home: TestExportPage(),
      home: DynamicTablePage(),
    );
  }
}

// import 'package:flutter/material.dart';

// import 'test/dynamic_db_helper.dart';
// import 'test/dynamic_table_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Dynamic SQLite Viewer',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const DynamicDbPage(),
//     );
//   }
// }

// class DynamicDbPage extends StatefulWidget {
//   const DynamicDbPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _DynamicDbPageState createState() => _DynamicDbPageState();
// }

// class _DynamicDbPageState extends State<DynamicDbPage> {
//   final dbHelper = DynamicDbHelper();
//   List<String> tables = [];

//   Future<void> _importDb() async {
//     final result = await dbHelper.importDatabase();
//     if (result) {
//       tables = await dbHelper.getAllTables();
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dynamic SQLite Viewer"),
//         actions: [
//           IconButton(icon: const Icon(Icons.file_open), onPressed: _importDb),
//         ],
//       ),
//       body: tables.isEmpty
//           ? const Center(child: Text("No database loaded"))
//           : ListView.builder(
//               itemCount: tables.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   child: ListTile(
//                     title: Text(tables[index]),
//                     trailing: const Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => DynamicTablePage(
//                             tableName: tables[index],
//                             dbHelper: dbHelper,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
