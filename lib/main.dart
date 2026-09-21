import 'package:flutter/material.dart';
import 'pages/home_pages.dart';

void main() {
  runApp(const KantinApp());
}

class KantinApp extends StatelessWidget {
  const KantinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kantin Kampus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}