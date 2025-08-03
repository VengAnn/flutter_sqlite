import 'package:flutter/material.dart';
import 'package:flutter_sqlite/pages/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SQLite Clean Example',
      // home: TestFetchImageFromGoogle(),
      home: ProductPage(),
    );
  }
}
