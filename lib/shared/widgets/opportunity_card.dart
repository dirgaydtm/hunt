import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'category_tag.dart';

class OpportunityCard extends StatelessWidget {
  final String title;
  final String organizer;
  final String category;
  final String? dateRange;
  final String? urgencyText;
  final Widget? logo;
  final String? imagePath;
  final VoidCallback? onTap;
  final bool hasBackground;

  const OpportunityCard({
    super.key,
    required this.title,
    required this.organizer,
    required this.category,
    this.dateRange,
    this.urgencyText,
    this.logo,
    this.imagePath,
    this.onTap,
    this.hasBackground = true,
  });

  Widget _buildFallbackLogo() {
    final theme = CategoryTheme.getTheme(category);

    final icon = switch (category.toLowerCase()) {
      'beasiswa' => Icons.school,
      'lomba' => Icons.emoji_events,
      _ => Icons.business,
    };

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: theme.light, shape: BoxShape.circle),
      child: Icon(icon, size: 24, color: theme.normal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CategoryTheme.getTheme(category);

    final finalLogo =
        logo ??
        (imagePath != null
            ? Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: .circular(10),
                  border: Border.all(color: AppColors.greyLightNormal),
                ),
                child: ClipRRect(
                  borderRadius: .circular(9),
                  child: Image.asset(imagePath!, fit: BoxFit.cover),
                ),
              )
            : _buildFallbackLogo());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: hasBackground ? theme.light : Colors.transparent,
          borderRadius: .circular(24),
          border: .all(color: theme.border),
          boxShadow: hasBackground
              ? [
                  BoxShadow(
                    color: theme.normal.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            finalLogo,
            SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        children: [
                          CategoryTag(category: category),
                          if (urgencyText != null)
                            Container(
                              margin: const .only(left: 8),
                              padding: const .symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orangeLight,
                                border: .all(color: AppColors.orangeNormal),
                                borderRadius: .circular(48),
                              ),
                              child: Text(
                                urgencyText!,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 8,
                                  fontWeight: AppFontWeight.semiBold,
                                  color: AppColors.orangeNormal,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (dateRange != null)
                        Text(
                          dateRange!,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 10,
                            color: AppColors.greyLightDarkActive,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.greyDarkNormal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    organizer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 10,
                      color: AppColors.greyLightDarkActive,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
