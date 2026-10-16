import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

typedef CategoryColors = ({
  Color normal,
  Color light,
  Color border,
  LinearGradient gradient,
});

CategoryColors categoryTheme(String category) =>
    switch (category.toLowerCase()) {
      'lomba' => (
        normal: AppColors.yellowDark,
        light: AppColors.yellowLightHover,
        border: AppColors.yellowNormal,
        gradient: AppColors.yellowGradient,
      ),
      'magang' => (
        normal: AppColors.greenNormal,
        light: AppColors.greenLight,
        border: AppColors.greenLightActive,
        gradient: AppColors.greenGradient,
      ),
      'beasiswa' => (
        normal: AppColors.blueNormal,
        light: AppColors.blueLight,
        border: AppColors.blueLightActive,
        gradient: AppColors.blueGradient,
      ),
      _ => (
        normal: AppColors.greyLightDarkActive,
        light: AppColors.greyDarkLight,
        border: AppColors.greyDarkLightActive,
        gradient: AppColors.blueGradient,
      ),
    };

class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = categoryTheme(category);

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
