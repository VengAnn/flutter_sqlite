import 'package:flutter/material.dart';

import 'pages/product_page.dart';

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
      title: 'Flutter SQLite Clean Example',
      // home: TestFetchImageFromGoogle(),
      home: ProductPage(),
    );
  }
}
