import 'package:flutter/material.dart';

import 'data/sumber_tugas_berhalaman.dart';
import 'presentation/pengendali_halaman.dart';
import 'screens/daftar_berhalaman_screen.dart';

class Modul11PengayaanApp extends StatefulWidget {
  const Modul11PengayaanApp({super.key});

  @override
  State<Modul11PengayaanApp> createState() => _Modul11PengayaanAppState();
}

class _Modul11PengayaanAppState extends State<Modul11PengayaanApp> {
  late final PengendaliHalaman _pengendali;

  @override
  void initState() {
    super.initState();
    _pengendali = PengendaliHalaman(
      SumberTugasSimulasi(gagalPadaHalaman: const <int>{3}),
      ukuranHalaman: 50,
    );
  }

  @override
  void dispose() {
    _pengendali.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modul 11 - Pagination',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1763B5)),
      ),
      home: DaftarBerhalamanScreen(pengendali: _pengendali),
    );
  }
}