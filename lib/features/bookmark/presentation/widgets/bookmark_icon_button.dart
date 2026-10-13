import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/opportunity_model.dart';
import '../providers/bookmark_provider.dart';

/// Compact bookmark toggle for list cards.
class BookmarkIconButton extends ConsumerWidget {
  final OpportunityModel opportunity;

  const BookmarkIconButton({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(isBookmarkedProvider(opportunity.id));
    return IconButton(
      visualDensity: VisualDensity.compact,
      tooltip: saved ? 'Hapus bookmark' : 'Simpan',
      icon: Icon(
        saved ? Icons.bookmark : Icons.bookmark_border,
        color: AppColors.blueNormal,
      ),
      onPressed: () async {
        final error = await ref
            .read(bookmarksProvider.notifier)
            .toggle(opportunity);
        if (error != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppColors.redNormal,
            ),
          );
        }
      },
    );
  }
}
