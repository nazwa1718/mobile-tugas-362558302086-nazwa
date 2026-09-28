import 'package:dio/dio.dart';

import '../../../modul_04/models/announcement.dart';

class AnnouncementRemoteDataSource {
  late final Dio _dio;

  AnnouncementRemoteDataSource() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print(
            'REQUEST: ${options.method} ${options.uri}',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            'RESPONSE: ${response.statusCode}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          print(
            'ERROR: ${error.type}',
          );
          handler.next(error);
        },
      ),
    );
  }

  Future<List<Announcement>> getAnnouncements() async {
    final response = await _dio.get('/posts');

    final data = response.data as List<dynamic>;

    final announcements = data
        .take(10)
        .map(
          (json) => Announcement.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();

    return _ubahKeBahasaIndonesia(announcements);
  }

  Future<Announcement> addAnnouncement(
    Announcement announcement,
  ) async {
    final response = await _dio.post(
      '/posts',
      data: announcement.toJson(),
    );

    final data = response.data as Map<String, dynamic>;

    return Announcement.fromJson(data);
  }

  List<Announcement> _ubahKeBahasaIndonesia(
    List<Announcement> data,
  ) {
    final dataIndonesia =
        Announcement.getSampleAnnouncements();

    final hasil = <Announcement>[];

    for (
      var i = 0;
      i < data.length && i < dataIndonesia.length;
      i++
    ) {
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
}