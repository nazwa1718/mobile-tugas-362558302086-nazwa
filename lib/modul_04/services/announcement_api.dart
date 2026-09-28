import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/announcement.dart';

class AnnouncementApi {
  static const String _baseUrl =
      'https://jsonplaceholder.typicode.com';

  // Mode simulasi digunakan untuk menampilkan data lokal.
  final bool modeSimulasi;

  AnnouncementApi({
    this.modeSimulasi = false,
  });

  // Mengambil data pengumuman dari REST API
  Future<List<Announcement>> ambilPengumuman() async {
    // Jika mode simulasi aktif, gunakan data lokal.
    if (modeSimulasi) {
      return Announcement.getSampleAnnouncements();
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts'),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data pengumuman',
        );
      }

      final List<dynamic> data =
          jsonDecode(response.body) as List<dynamic>;

      final pengumuman = data
          .take(10)
          .map(
            (json) => Announcement.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      // Mengubah data API menjadi data pengumuman
      // berbahasa Indonesia.
      return _ubahKeBahasaIndonesia(pengumuman);
    } catch (e) {
      // Jika REST API gagal, gunakan data lokal.
      return Announcement.getSampleAnnouncements();
    }
  }

  // Mengubah data dari JSONPlaceholder menjadi
  // data pengumuman berbahasa Indonesia.
  List<Announcement> _ubahKeBahasaIndonesia(
    List<Announcement> data,
  ) {
    final dataIndonesia = [
      const Announcement(
        id: 1,
        title: 'Jadwal Pengisian KRS Semester Ganjil 2026/2027',
        content:
            'Pengisian Kartu Rencana Studi (KRS) untuk mahasiswa '
            'semester 3 dimulai tanggal 1 hingga 7 September 2026. '
            'Pastikan mahasiswa telah menyelesaikan bimbingan '
            'dengan dosen wali.',
        author: 'Bagian Akademik Poliwangi',
        category: 'Akademik',
        date: '2026-09-01',
        readCount: 37,
      ),
      const Announcement(
        id: 2,
        title: 'Pendaftaran Beasiswa Pendidikan Tahun 2026',
        content:
            'Mahasiswa yang memenuhi persyaratan dapat mengikuti '
            'program beasiswa pendidikan tahun 2026. '
            'Segera lengkapi dokumen dan persyaratan administrasi '
            'sebelum batas waktu pendaftaran.',
        author: 'Bagian Kemahasiswaan Poliwangi',
        category: 'Beasiswa',
        date: '2026-09-02',
        readCount: 74,
      ),
      const Announcement(
        id: 3,
        title: 'Kegiatan Seminar Teknologi Informasi',
        content:
            'Akan dilaksanakan seminar mengenai perkembangan '
            'teknologi informasi dan pengembangan aplikasi mobile. '
            'Seluruh mahasiswa diharapkan dapat mengikuti kegiatan '
            'sesuai jadwal yang telah ditentukan.',
        author: 'Program Studi TRPL',
        category: 'Kegiatan',
        date: '2026-09-03',
        readCount: 56,
      ),
      const Announcement(
        id: 4,
        title: 'Prestasi Mahasiswa TRPL di Kompetisi Nasional',
        content:
            'Selamat kepada mahasiswa Program Studi TRPL yang '
            'berhasil meraih prestasi dalam kompetisi pengembangan '
            'aplikasi tingkat nasional.',
        author: 'Himpunan Mahasiswa TRPL',
        category: 'Prestasi',
        date: '2026-09-04',
        readCount: 125,
      ),
      const Announcement(
        id: 5,
        title: 'Pengumuman Jadwal Perkuliahan Semester Ganjil',
        content:
            'Jadwal perkuliahan semester ganjil telah diterbitkan. '
            'Mahasiswa dapat melihat jadwal mata kuliah melalui '
            'sistem akademik Poliwangi.',
        author: 'Bagian Akademik Poliwangi',
        category: 'Akademik',
        date: '2026-09-05',
        readCount: 98,
      ),
      const Announcement(
        id: 6,
        title: 'Informasi Program Magang Mahasiswa',
        content:
            'Program magang bagi mahasiswa yang memenuhi persyaratan '
            'akan segera dibuka. Informasi mengenai perusahaan mitra '
            'dan persyaratan pendaftaran akan diumumkan lebih lanjut.',
        author: 'Koordinator Magang TRPL',
        category: 'Kegiatan',
        date: '2026-09-06',
        readCount: 83,
      ),
      const Announcement(
        id: 7,
        title: 'Informasi Bantuan Pendidikan Mahasiswa',
        content:
            'Poliwangi menyediakan informasi mengenai bantuan '
            'pendidikan bagi mahasiswa yang memenuhi persyaratan. '
            'Silakan menghubungi bagian kemahasiswaan untuk informasi '
            'lebih lanjut.',
        author: 'Bagian Kemahasiswaan Poliwangi',
        category: 'Beasiswa',
        date: '2026-09-07',
        readCount: 67,
      ),
      const Announcement(
        id: 8,
        title: 'Mahasiswa TRPL Meraih Juara Kompetisi Mobile',
        content:
            'Tim mahasiswa TRPL berhasil meraih juara dalam '
            'kompetisi pengembangan aplikasi mobile. Prestasi ini '
            'menjadi kebanggaan bagi Program Studi TRPL.',
        author: 'Program Studi TRPL',
        category: 'Prestasi',
        date: '2026-09-08',
        readCount: 156,
      ),
      const Announcement(
        id: 9,
        title: 'Jadwal Ujian Tengah Semester',
        content:
            'Ujian Tengah Semester akan dilaksanakan sesuai '
            'jadwal yang telah ditentukan oleh program studi. '
            'Mahasiswa diharapkan mempersiapkan diri dengan baik.',
        author: 'Bagian Akademik Poliwangi',
        category: 'Akademik',
        date: '2026-09-09',
        readCount: 112,
      ),
      const Announcement(
        id: 10,
        title: 'Workshop Pengembangan Aplikasi Flutter',
        content:
            'Program Studi TRPL akan mengadakan workshop '
            'pengembangan aplikasi menggunakan Flutter. '
            'Kegiatan terbuka bagi mahasiswa yang ingin '
            'meningkatkan kemampuan pengembangan aplikasi mobile.',
        author: 'Program Studi TRPL',
        category: 'Kegiatan',
        date: '2026-09-10',
        readCount: 91,
      ),
    ];

    final hasil = <Announcement>[];

    for (var i = 0; i < data.length && i < dataIndonesia.length; i++) {
      hasil.add(
        Announcement(
          id: data[i].id,
          title: dataIndonesia[i].title,
          content: dataIndonesia[i].content,
          author: dataIndonesia[i].author,
          category: dataIndonesia[i].category,
          date: dataIndonesia[i].date,
          readCount: dataIndonesia[i].readCount,
        ),
      );
    }

    return hasil;
  }

  // Method ini dipanggil oleh AnnouncementListScreen.
  // Package http tidak membutuhkan dispose/close seperti Dio.
  void tutup() {
    // Tidak ada resource yang perlu ditutup.
  }
}