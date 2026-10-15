import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

const _tabs = [
  ('/home', Icons.home_outlined, Icons.home, 'Home'),
  (
    '/calendar',
    Icons.calendar_month_outlined,
    Icons.calendar_month,
    'Calendar',
  ),
  ('/bookmark', Icons.bookmark_outline, Icons.bookmark, 'Bookmark'),
  ('/profile', Icons.person_outline, Icons.person, 'Profile'),
];

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.blueNormal),

        Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 10,
            fontWeight: isActive ? AppFontWeight.bold : AppFontWeight.regular,
            color: AppColors.blueNormal,
          ),
        ),
        SizedBox(height: 6),
        Container(
          height: 1,
          width: 58,
          decoration: BoxDecoration(
            color: isActive ? AppColors.blueNormal : Colors.transparent,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Admins manage content, they don't bookmark it.
    final isAdmin = ref.watch(authProvider).value?.isAdmin ?? false;
    final tabs = [
      for (final t in _tabs)
        if (!(isAdmin && t.$1 == '/bookmark')) t,
    ];
    final location = GoRouterState.of(context).matchedLocation;
    final index = tabs.indexWhere((t) => location.startsWith(t.$1));

    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: SizedBox(
        height: 95 + MediaQuery.paddingOf(context).bottom,
        child: BottomNavigationBar(
          currentIndex: index < 0 ? 0 : index,
          onTap: (i) => context.go(tabs[i].$1),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 8,
          iconSize: 24,
          selectedItemColor: AppColors.blueNormal,
          unselectedItemColor: AppColors.blueNormal,
          selectedLabelStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 10,
            fontWeight: AppFontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 10,
            fontWeight: AppFontWeight.regular,
          ),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            for (final (_, icon, activeIcon, label) in tabs)
              BottomNavigationBarItem(
                icon: _buildNavItem(icon, label),
                activeIcon: _buildNavItem(activeIcon, label, isActive: true),
                label: label,
              ),
          ],
        ),
      ),
    );
  }
}
