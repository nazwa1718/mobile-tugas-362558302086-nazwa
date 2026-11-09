import 'package:flutter/foundation.dart';

import '../../../modul_11/modul_11_app.dart';
import '../data/sumber_tugas_berhalaman.dart';

class PengendaliHalaman extends ChangeNotifier {
  PengendaliHalaman(this.sumber, {this.ukuranHalaman = 50});

  final SumberTugasBerhalaman sumber;
  final int ukuranHalaman;

  final List<TugasPerforma> _item = <TugasPerforma>[];
  List<TugasPerforma> get item => List<TugasPerforma>.unmodifiable(_item);

  String? _galat;
  String? get galat => _galat;

  bool _memuat = false;
  bool get memuat => _memuat;

  bool _adaBerikutnya = true;
  bool get adaBerikutnya => _adaBerikutnya;

  int _halamanBerikut = 1;
  int get halamanBerikut => _halamanBerikut;

  Future<void> muatBerikutnya() async {
    // Abaikan panggilan ganda saat memuat / sudah habis.
    if (_memuat || !_adaBerikutnya) return;

    _memuat = true;
    _galat = null;
    notifyListeners();

    final int halamanDiminta = _halamanBerikut;

    try {
      final HalamanTugas hasil = await sumber.ambil(
        halaman: halamanDiminta,
        ukuran: ukuranHalaman,
      );
      _item.addAll(hasil.item);
      _adaBerikutnya = hasil.adaBerikutnya;
      if (_adaBerikutnya) _halamanBerikut = halamanDiminta + 1;
    } catch (e) {
      _galat = e.toString(); // berisi 'halaman 2'
      // Nomor halaman TIDAK naik → coba lagi meminta halaman yang sama.
    } finally {
      _memuat = false;
      notifyListeners();
    }
  }

  Future<void> muatUlang() async {
    _item.clear();
    _halamanBerikut = 1;
    _adaBerikutnya = true;
    _galat = null;
    notifyListeners();
    await muatBerikutnya();
  }
}