import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/hunt_text_field.dart';
import '../../../../core/data/opportunity_repository.dart';
import '../../../../core/models/opportunity_model.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../notifications/presentation/widgets/notification_bell.dart';
import '../providers/bookmark_provider.dart';

class BookmarkHeader extends ConsumerStatefulWidget {
  const BookmarkHeader({super.key});

  @override
  ConsumerState<BookmarkHeader> createState() => _BookmarkHeaderState();
}

class _BookmarkHeaderState extends ConsumerState<BookmarkHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(bookmarkFiltersProvider).query,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _update(SearchFilters Function(SearchFilters) change) {
    final notifier = ref.read(bookmarkFiltersProvider.notifier);
    notifier.set(change(ref.read(bookmarkFiltersProvider)));
  }

  void _showFilter(BuildContext context) async {
    final result = await showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FilterSheet(initialFilters: ref.read(bookmarkFiltersProvider)),
    );
    if (result != null) _update((_) => result);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(bookmarkFiltersProvider).category;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blueNormal,
        borderRadius: .vertical(bottom: .circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueNormal.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: .only(top: 24, left: 32, right: 32, bottom: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: HuntTextField(
                      controller: _searchController,
                      hintText: 'Cari bookmark ...',
                      prefixIcon: Icons.search,
                      suffixIcon: GestureDetector(
                        onTap: () => _showFilter(context),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.greyLightDark,
                          size: 20,
                        ),
                      ),
                      onChanged: (val) =>
                          _update((f) => f.copyWith(query: val)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const NotificationBell(),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: categoryFilters.map((cat) {
                  final isSelected = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () => _update((f) => f.copyWith(category: cat)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: .symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.blueDark
                            : Colors.transparent,
                        borderRadius: .circular(20),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? AppFontWeight.bold
                              : AppFontWeight.regular,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
