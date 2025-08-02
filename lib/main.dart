import 'package:flutter/material.dart';
import 'package:flutter_sqlite/pages/test_fetch_image_from_google.dart';

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
      home: TestFetchImageFromGoogle(),
    );
  }
}
