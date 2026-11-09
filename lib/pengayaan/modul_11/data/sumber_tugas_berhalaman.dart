import '../../../modul_11/modul_11_app.dart';

/// Hasil satu halaman.
class HalamanTugas {
  const HalamanTugas({required this.item, required this.adaBerikutnya});

  final List<TugasPerforma> item;
  final bool adaBerikutnya;
}

/// Kontrak sumber berhalaman (mirip GET /tugas?page=2&size=50).
abstract class SumberTugasBerhalaman {
  Future<HalamanTugas> ambil({required int halaman, required int ukuran});
}

/// Simulasi server: jeda buatan, total data, gagal pada halaman tertentu.
class SumberTugasSimulasi implements SumberTugasBerhalaman {
  SumberTugasSimulasi({
    this.total = 1000,
    this.jeda = const Duration(milliseconds: 800),
    this.gagalPadaHalaman = const <int>{},
  });

  final int total;
  final Duration jeda;
  final Set<int> gagalPadaHalaman;

  // Tambahkan set ini untuk melacak halaman mana yang sudah pernah gagal
  final Set<int> _sudahGagal = <int>{};
  
  late final List<TugasPerforma> _data = buatTugasContoh(jumlah: total);

  @override
  Future<HalamanTugas> ambil({required int halaman, required int ukuran}) async {
    await Future<void>.delayed(jeda);

    // Ubah logika ini: Hanya gagal jika belum pernah gagal
    if (gagalPadaHalaman.contains(halaman) && !_sudahGagal.contains(halaman)) {
      _sudahGagal.add(halaman);
      throw Exception('Gagal memuat halaman $halaman');
    }

    final int mulai = (halaman - 1) * ukuran;
    if (mulai >= _data.length) {
      return const HalamanTugas(item: <TugasPerforma>[], adaBerikutnya: false);
    }

    final int akhir = (mulai + ukuran).clamp(0, _data.length);
    final List<TugasPerforma> potongan = _data.sublist(mulai, akhir);

    return HalamanTugas(
      item: potongan,
      adaBerikutnya: akhir < _data.length,
    );
  }
}