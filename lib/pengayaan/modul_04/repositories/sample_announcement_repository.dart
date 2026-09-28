import '../../../modul_04/models/announcement.dart';
import 'announcement_repository.dart';

class SampleAnnouncementRepository
    implements AnnouncementRepository {
  final List<Announcement> _items =
      List<Announcement>.of(
    Announcement.getSampleAnnouncements(),
  );

  @override
  Future<List<Announcement>> getAnnouncements({
    String? category,
  }) async {
    if (category == null || category == 'Semua') {
      return List<Announcement>.of(_items);
    }

    return _items
        .where(
          (announcement) =>
              announcement.category == category,
        )
        .toList();
  }

  @override
  Future<Announcement> addAnnouncement(
    Announcement announcement,
  ) async {
    _items.add(announcement);
    return announcement;
  }
}