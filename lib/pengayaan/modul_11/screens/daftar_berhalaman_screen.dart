import 'package:flutter/material.dart';

import '../../../modul_11/modul_11_app.dart';
import '../presentation/pengendali_halaman.dart';

class DaftarBerhalamanScreen extends StatefulWidget {
  const DaftarBerhalamanScreen({super.key, required this.pengendali});

  final PengendaliHalaman pengendali;

  @override
  State<DaftarBerhalamanScreen> createState() => _DaftarBerhalamanScreenState();
}

class _DaftarBerhalamanScreenState extends State<DaftarBerhalamanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.pengendali.muatBerikutnya();
    });
  }

  bool _onScroll(ScrollNotification notif) {
    if (notif.metrics.extentAfter < 400) {
      widget.pengendali.muatBerikutnya();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Kuliah (Berhalaman)'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: widget.pengendali.muatUlang,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.pengendali,
        builder: (BuildContext context, _) {
          final PengendaliHalaman p = widget.pengendali;
          final List<TugasPerforma> daftar = p.item;

          if (daftar.isEmpty && p.memuat) {
            return const Center(child: CircularProgressIndicator());
          }
          if (daftar.isEmpty && p.galat != null) {
            return _PanelGalat(pesan: p.galat!, onCoba: p.muatBerikutnya);
          }

          return NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: ListView.builder(
              key: const ValueKey<String>('task-list'),
              itemCount: daftar.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < daftar.length) {
                  return _KartuTugasBerhalaman(tugas: daftar[index]);
                }
                return _FooterState(pengendali: p);
              },
            ),
          );
        },
      ),
    );
  }
}

class _FooterState extends StatelessWidget {
  const _FooterState({required this.pengendali});

  final PengendaliHalaman pengendali;

  @override
  Widget build(BuildContext context) {
    if (pengendali.memuat) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (pengendali.galat != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: _PanelGalat(
          pesan: pengendali.galat!,
          onCoba: pengendali.muatBerikutnya,
        ),
      );
    }
    if (!pengendali.adaBerikutnya) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Semua ${pengendali.item.length} tugas sudah dimuat.',
            style: const TextStyle(fontSize: 15, color: Color(0xFF64748B)),
          ),
        ),
      );
    }
    return const SizedBox(height: 24);
  }
}

class _PanelGalat extends StatelessWidget {
  const _PanelGalat({required this.pesan, required this.onCoba});

  final String pesan;
  final VoidCallback onCoba;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF5B5B5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            pesan,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9B1C1C),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onCoba,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}

class _KartuTugasBerhalaman extends StatelessWidget {
  const _KartuTugasBerhalaman({required this.tugas});

  final TugasPerforma tugas;

  @override
  Widget build(BuildContext context) {
    final bool selesai = tugas.selesai;
    return Container(
      key: ValueKey<String>('task-card-${tugas.nomor}'),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                  style: const TextStyle(fontSize: 15, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
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