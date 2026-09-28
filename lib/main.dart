import 'package:flutter/material.dart';

import 'modul_04/screens/announcement_list_screen.dart';

void main() {
  runApp(const Modul04App());
}

class Modul04App extends StatelessWidget {
  const Modul04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portal Pengumuman',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const AnnouncementListScreen(),
    );
  }
}