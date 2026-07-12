import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'filter_sheet.dart';
import 'home_search_bar.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.value?.name ?? 'Guest';
    final firstName = userName.split(' ').first;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.blueNormal,
        borderRadius: .vertical(bottom: .circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueNormal.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const .only(top: 60, left: 32, right: 32, bottom: 28),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .end,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Halo, $firstName!',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          fontWeight: AppFontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Selamat berburu peluang!',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: .all(12),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              HomeSearchBar(
                onTap: () => context.push('/search', extra: ''),
                onFilterTap: () => _showFilter(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
