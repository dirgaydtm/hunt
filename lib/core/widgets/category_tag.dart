import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CategoryTheme {
  static ({Color normal, Color light, Color border}) getTheme(String category) {
    switch (category.toLowerCase()) {
      case 'lomba':
        return (
          normal: AppColors.yellowDark,
          light: AppColors.yellowLightHover,
          border: AppColors.yellowNormal,
        );

      case 'magang':
        return (
          normal: AppColors.greenNormal,
          light: AppColors.greenLight,
          border: AppColors.greenLightActive,
        );

      case 'beasiswa':
        return (
          normal: AppColors.blueNormal,
          light: AppColors.blueLight,
          border: AppColors.blueLightActive,
        );

      default:
        return (
          normal: AppColors.greyLightDarkActive,
          light: AppColors.greyDarkLight,
          border: AppColors.greyDarkLightActive,
        );
    }
  }
}

class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = CategoryTheme.getTheme(category);

    return Container(
      padding: .symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: theme.light,
        border: .all(color: theme.border),
        borderRadius: .circular(12),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 8,
          fontWeight: AppFontWeight.semiBold,
          color: theme.normal,
        ),
      ),
    );
  }
}
