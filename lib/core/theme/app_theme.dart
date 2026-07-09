import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blueNormal,
        primary: AppColors.blueNormal,
        secondary: AppColors.greenNormal,
        error: AppColors.redNormal,
      ),
    );
  }
}
