import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/hunt_text_field.dart';
import '../../../../shared/widgets/filter_sheet.dart';
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
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(bookmarkCategoryProvider);
    final categories = ['Semua', 'Beasiswa', 'Lomba', 'Magang'];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blueNormal,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
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
          padding: const EdgeInsets.only(
            top: 24,
            left: 32,
            right: 32,
            bottom: 24,
          ),
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
                      onChanged: (val) {
                        ref
                            .read(bookmarkSearchQueryProvider.notifier)
                            .setQuery(val);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categories.map((cat) {
                  final isSelected = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () => ref
                        .read(bookmarkCategoryProvider.notifier)
                        .setCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.blueDark
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
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
