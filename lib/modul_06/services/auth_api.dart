
import '../models/sesi_pengguna.dart';

/// Kegagalan autentikasi yang aman ditampilkan ke pengguna.
class AuthException implements Exception {
  final String pesan;
  final int kode;

  const AuthException(this.pesan, {this.kode = 401});

  @override
  String toString() => 'AuthException($kode): $pesan';
}

/// API login tiruan: tidak menyentuh jaringan.
class AuthApi {
  // Penghitung untuk eksperimen Soal 2.
  int jumlahPemanggilanMasuk = 0;

  static const String emailDemo = 'student@trpl.test';
  static const String sandiDemo = 'belajar123';
  static const String emailTerkunci = 'terkunci@trpl.test';
  static const String emailServerGangguan = 'gangguan@trpl.test';

  /// Jeda buatan untuk memperlihatkan status memproses.
  final Duration tunda;

  AuthApi({
    this.tunda = const Duration(milliseconds: 700),
  });

  Future<SesiPengguna> masuk({
    required String email,
    required String sandi,
    Duration masaBerlaku = const Duration(hours: 2),
  }) async {
    // Hitung sebelum await, termasuk login yang gagal.
    jumlahPemanggilanMasuk++;

    await Future<void>.delayed(tunda);

    final String emailBersih = email.trim().toLowerCase();

    if (emailBersih.isEmpty || sandi.isEmpty) {
      throw const AuthException(
        'Email dan kata sandi wajib diisi.',
        kode: 400,
      );
    }

    if (emailBersih == emailTerkunci) {
      throw const AuthException(
        'Akun terkunci sementara karena terlalu banyak percobaan. '
        'Coba lagi beberapa menit lagi.',
        kode: 423,
      );
    }

    if (emailBersih == emailServerGangguan) {
      throw const AuthException(
        'Server sedang tidak dapat dihubungi. '
        'Periksa koneksi lalu coba lagi.',
        kode: 503,
      );
    }

    if (emailBersih != emailDemo || sandi != sandiDemo) {
      throw const AuthException('Email atau kata sandi salah.');
    }

    final DateTime mulai = DateTime.now();

    return SesiPengguna(
      token: 'dummy.${mulai.millisecondsSinceEpoch}.trpl',
      email: emailBersih,
      nama: _namaUntuk(emailBersih),
      peran: 'mahasiswa',
      masukPada: mulai.toIso8601String(),
      kedaluwarsaPada:
          mulai.add(masaBerlaku).toIso8601String(),
    );
  }

  /// Memperbarui masa berlaku sesi.
  Future<SesiPengguna> perbaruiSesi(
    SesiPengguna sesi, {
    Duration masaBerlaku = const Duration(hours: 2),
  }) async {
    await Future<void>.delayed(tunda);

    final DateTime mulai = DateTime.now();

    return sesi.copyWith(
      masukPada: mulai.toIso8601String(),
      kedaluwarsaPada:
          mulai.add(masaBerlaku).toIso8601String(),
    );
  }

  static String _namaUntuk(String email) {
    if (email == emailDemo) return 'Mahasiswa TRPL';

    final String depan = email.split('@').first;

    if (depan.isEmpty) return 'Pengguna';

    return '${depan[0].toUpperCase()}'
        '${depan.substring(1)}';
  }
}
