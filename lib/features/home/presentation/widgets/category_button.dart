import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color lightColor;

  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search', extra: label),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: lightColor,
              border: .all(color: color, width: 1),
              borderRadius: .circular(24),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          SizedBox(height: 12),
          Text(
            label,
            textAlign: .center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12,
              fontWeight: AppFontWeight.bold,
              color: AppColors.greyDarkNormal,
            ),
          ),
        ],
      ),
    );
  }
}
