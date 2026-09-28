import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modul_04/models/announcement.dart';
import '../datasources/announcement_remote_datasource.dart';
import '../repositories/announcement_repository.dart';
import '../repositories/announcement_repository_impl.dart';
import '../repositories/sample_announcement_repository.dart';

/// Menentukan apakah aplikasi menggunakan data sample.
final useSampleDataProvider = Provider<bool>((ref) {
  const value = String.fromEnvironment(
    'USE_SAMPLE_DATA',
    defaultValue: 'false',
  );

  return value.toLowerCase() == 'true';
});

/// Menentukan repository yang digunakan aplikasi.
final announcementRepositoryProvider =
    Provider<AnnouncementRepository>((ref) {
  final useSampleData =
      ref.watch(useSampleDataProvider);

  if (useSampleData) {
    return SampleAnnouncementRepository();
  }

  return AnnouncementRepositoryImpl(
    remoteDataSource:
        AnnouncementRemoteDataSource(),
  );
});

/// Menyimpan kategori yang sedang dipilih.
final selectedCategoryProvider =
    NotifierProvider<
      SelectedCategoryNotifier,
      String
    >(
      SelectedCategoryNotifier.new,
    );

class SelectedCategoryNotifier
    extends Notifier<String> {
  @override
  String build() {
    return 'Semua';
  }

  void select(String category) {
    state = category;
  }
}

/// Mengambil data pengumuman berdasarkan kategori.
final announcementsProvider =
    FutureProvider<List<Announcement>>((ref) async {
  final repository =
      ref.watch(announcementRepositoryProvider);

  final category =
      ref.watch(selectedCategoryProvider);

  return repository.getAnnouncements(
    category: category,
  );
});