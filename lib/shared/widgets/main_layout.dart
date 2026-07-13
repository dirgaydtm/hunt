import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return switch (location) {
      _ when location.startsWith('/calendar') => 1,
      _ when location.startsWith('/bookmark') => 2,
      _ when location.startsWith('/profile') => 3,
      _ => 0,
    };
  }

  void _onTap(BuildContext context, int index) {
    const routes = ['/home', '/calendar', '/bookmark', '/profile'];

    context.go(routes[index]);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: SizedBox(
        height: 95 + MediaQuery.paddingOf(context).bottom,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex(context),
          onTap: (index) => _onTap(context, index),
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
            BottomNavigationBarItem(
              icon: _buildNavItem(Icons.home_outlined, 'Home'),
              activeIcon: _buildNavItem(Icons.home, 'Home', isActive: true),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(Icons.calendar_month_outlined, 'Calendar'),
              activeIcon: _buildNavItem(
                Icons.calendar_month,
                'Calendar',
                isActive: true,
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(Icons.bookmark_outline, 'Bookmark'),
              activeIcon: _buildNavItem(
                Icons.bookmark,
                'Bookmark',
                isActive: true,
              ),
              label: 'Bookmark',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(Icons.person_outline, 'Profile'),
              activeIcon: _buildNavItem(
                Icons.person,
                'Profile',
                isActive: true,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
