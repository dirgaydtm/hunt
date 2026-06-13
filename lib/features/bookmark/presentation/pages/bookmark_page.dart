import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/opportunity_card.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/bookmark_header.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBookmarks = ref.watch(filteredBookmarksProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const BookmarkHeader(),
          Expanded(
            child: asyncBookmarks.when(
              data: (bookmarks) {
                if (bookmarks.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada bookmark di kategori ini.',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.greyLightDarkActive,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final item = bookmarks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OpportunityCard(
                        title: item.title,
                        organizer: item.organizer,
                        category: item.category,
                        urgencyText: item.urgencyText,
                        imagePath: item.imagePath,
                        hasBackground: true,
                        onTap: () {
                          context.push('/detail', extra: item);
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
