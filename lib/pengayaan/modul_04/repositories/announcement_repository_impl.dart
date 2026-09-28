import 'package:dio/dio.dart';

import '../../../modul_04/models/announcement.dart';
import '../datasources/announcement_remote_datasource.dart';
import 'announcement_repository.dart';

class AnnouncementRepositoryImpl
    implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Announcement>> getAnnouncements({
    String? category,
  }) async {
    try {
      final announcements =
          await remoteDataSource.getAnnouncements();

      if (category == null || category == 'Semua') {
        return announcements;
      }

      return announcements
          .where(
            (announcement) =>
                announcement.category == category,
          )
          .toList();
    } on DioException catch (e) {
      String errorMessage;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage =
              'Koneksi ke server timeout. Periksa sambungan internet Anda.';
          break;

        case DioExceptionType.connectionError:
          errorMessage =
              'Gagal terhubung ke server. Periksa koneksi data atau Wi-Fi Anda.';
          break;

        case DioExceptionType.badResponse:
          errorMessage =
              'Server merespons dengan kesalahan (${e.response?.statusCode}).';
          break;

        default:
          errorMessage =
              'Terjadi kendala jaringan: ${e.message ?? 'Kesalahan tidak diketahui'}';
      }

      throw Exception(errorMessage);
    }
  }

  @override
  Future<Announcement> addAnnouncement(
    Announcement announcement,
  ) async {
    try {
      return await remoteDataSource.addAnnouncement(
        announcement,
      );
    } on DioException catch (e) {
      String errorMessage;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage =
              'Koneksi ke server timeout. Periksa sambungan internet Anda.';
          break;

        case DioExceptionType.connectionError:
          errorMessage =
              'Gagal terhubung ke server. Periksa koneksi data atau Wi-Fi Anda.';
          break;

        case DioExceptionType.badResponse:
          errorMessage =
              'Server merespons dengan kesalahan (${e.response?.statusCode}).';
          break;

        default:
          errorMessage =
              'Terjadi kendala jaringan: ${e.message ?? 'Kesalahan tidak diketahui'}';
      }

      throw Exception(errorMessage);
    }
  }
}