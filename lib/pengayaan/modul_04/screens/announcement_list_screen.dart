import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modul_04/widgets/announcement_card.dart';
import '../providers/announcement_provider.dart';

class AnnouncementListScreen extends ConsumerWidget {
  const AnnouncementListScreen({super.key});

  static const List<String> categories = [
    'Semua',
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory =
        ref.watch(selectedCategoryProvider);

    final asyncAnnouncements =
        ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portal Pengumuman TRPL',
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: categories.map((kategori) {
                final isSelected =
                    selectedCategory == kategori;

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  child: ChoiceChip(
                    label: Text(kategori),
                    selected: isSelected,
                    onSelected: (_) {
                      ref
                          .read(
                            selectedCategoryProvider
                                .notifier,
                          )
                          .select(kategori);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: asyncAnnouncements.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),

              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Terjadi kesalahan:\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              data: (announcements) {
                if (announcements.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada pengumuman.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement =
                        announcements[index];

                   return AnnouncementCard(
                      announcement: announcement,
                      onTap: () {  // Aksi ketika kartu pengumuman ditekan.
  },
);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}