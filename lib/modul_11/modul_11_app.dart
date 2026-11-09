import 'package:flutter/material.dart';

enum StatusTugas { aktif, selesai }

class TugasPerforma {
  const TugasPerforma({
    required this.nomor,
    required this.mataKuliah,
    required this.selesai,
  });

  final int nomor;
  final String mataKuliah;
  final bool selesai;

  String get judul => 'Tugas praktikum ${nomor.toString().padLeft(4, '0')}';

  StatusTugas get status => selesai ? StatusTugas.selesai : StatusTugas.aktif;

  // TAMBAHKAN GETTER INI
  String get kunciPencarian =>
      '${judul.toLowerCase()} ${mataKuliah.toLowerCase()}';
}

/// Membuat data contoh. Default 1000 tugas, 250 selesai.
List<TugasPerforma> buatTugasContoh({int jumlah = 1000}) {
  const List<String> mataKuliah = <String>[
    'Pemrograman Mobile',
    'Basis Data',
    'Jaringan Komputer',
    'Rekayasa Perangkat Lunak',
    'Sistem Operasi',
    'Kecerdasan Buatan',
    'Pemrograman Web',
    'Analisis dan Perancangan Sistem',
  ];

  return List<TugasPerforma>.generate(jumlah, (int index) {
    final int nomor = index + 1;
    final String namaMataKuliah = mataKuliah[index % 8];

    final bool selesai;
    if (namaMataKuliah == 'Basis Data') {
      final int urutanBasisData = (index ~/ 8) + 1;
      selesai = urutanBasisData >= 3 && (urutanBasisData - 3) % 4 == 0;
    } else {
      selesai = nomor % 4 == 0 && nomor <= 876;
    }

    return TugasPerforma(
      nomor: nomor,
      mataKuliah: namaMataKuliah,
      selesai: selesai,
    );
  });
}

/// Kriteria filter immutable.
class KriteriaFilter {
  const KriteriaFilter({this.kueri = '', this.status});

  final String kueri;
  final StatusTugas? status;

  KriteriaFilter salinDengan({
    String? kueri,
    StatusTugas? status,
    bool hapusStatus = false,
  }) {
    return KriteriaFilter(
      kueri: kueri ?? this.kueri,
      status: hapusStatus ? null : (status ?? this.status),
    );
  }
}

/// Menyaring daftar tanpa mengubah sumber.
/// Menyaring daftar tanpa mengubah sumber.
List<TugasPerforma> saringTugas(
  List<TugasPerforma> sumber,
  KriteriaFilter kriteria,
) {
  final String kueri = kriteria.kueri.trim().toLowerCase();
  return sumber.where((TugasPerforma t) {
    final bool cocokStatus =
        kriteria.status == null || t.status == kriteria.status;
    
    // Cek langsung teksnya
    final String teksTugas = '${t.judul} ${t.mataKuliah}'.toLowerCase();
    final bool cocokTeks = kueri.isEmpty || teksTugas.contains(kueri);
    
    return cocokStatus && cocokTeks;
  }).toList(growable: false);
}

class Modul11App extends StatelessWidget {
  const Modul11App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modul 11 - Optimasi Daftar Tugas',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1763B5)),
      ),
      home: const LayarDaftarTugasPerforma(),
    );
  }
}

class LayarDaftarTugasPerforma extends StatefulWidget {
  const LayarDaftarTugasPerforma({super.key});

  @override
  State<LayarDaftarTugasPerforma> createState() =>
      _LayarDaftarTugasPerformaState();
}

class _LayarDaftarTugasPerformaState extends State<LayarDaftarTugasPerforma> {
  final TextEditingController _pencarian = TextEditingController();
  final List<TugasPerforma> _semuaTugas = buatTugasContoh();

  StatusTugas? _filter;
  String _kueri = '';

  List<TugasPerforma> get _hasil => saringTugas(
        _semuaTugas,
        KriteriaFilter(kueri: _kueri, status: _filter),
      );

  @override
  void dispose() {
    _pencarian.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TugasPerforma> hasil = _hasil;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 22),
                    child: Text(
                      'Tugas Kuliah',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101A3A),
                      ),
                    ),
                  ),
                  TextField(
                    key: const ValueKey<String>('task-search'),
                    controller: _pencarian,
                    onChanged: (String value) =>
                        setState(() => _kueri = value),
                    decoration: InputDecoration(
                      hintText: 'Cari tugas atau mata kuliah',
                      hintStyle: const TextStyle(
                        color: Color(0xFF526078),
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF475569), size: 27),
                      filled: true,
                      fillColor: const Color(0xFFEDF2FC),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 19, horizontal: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: const BorderSide(
                            color: Color(0xFF1763B5), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: <Widget>[
                      _filterChip('Semua', null),
                      _filterChip('Aktif', StatusTugas.aktif),
                      _filterChip('Selesai', StatusTugas.selesai),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Menampilkan ${hasil.length} dari '
                      '${_semuaTugas.length} tugas',
                      key: const ValueKey<String>('result-count'),
                      style: const TextStyle(
                          fontSize: 17, color: Color(0xFF64748B)),
                    ),
                  ),
                  Expanded(
                    child: hasil.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada tugas yang cocok.',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF64748B)),
                            ),
                          )
                        : ListView.builder(
                            key: const ValueKey<String>('task-list'),
                            itemCount: hasil.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _KartuTugas(tugas: hasil[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, StatusTugas? status) {
    final bool selected = _filter == status;
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => setState(() => _filter = status),
      backgroundColor: const Color(0xFFEDF2FC),
      selectedColor: const Color(0xFF1763B5),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF334155),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    );
  }
}

class _KartuTugas extends StatelessWidget {
  const _KartuTugas({required this.tugas});

  final TugasPerforma tugas;

  @override
  Widget build(BuildContext context) {
    final bool selesai = tugas.selesai;
    return Container(
      key: ValueKey<String>('task-card-${tugas.nomor}'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1E8F0)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tugas.judul,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101A3A),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tugas.mataKuliah,
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            decoration: BoxDecoration(
              color: selesai
                  ? const Color(0xFFE5F0FF)
                  : const Color(0xFFE3F7EF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              selesai ? 'Selesai' : 'Aktif',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selesai
                    ? const Color(0xFF0759B5)
                    : const Color(0xFF08704B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}