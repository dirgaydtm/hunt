import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onFilterTap;

  const HomeSearchBar({
    super.key,
    required this.onTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.greyLightDark, size: 20),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Cari peluang ...',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.greyLightDark,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onFilterTap,
              child: Icon(
                Icons.tune_rounded,
                color: AppColors.greyLightDark,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
