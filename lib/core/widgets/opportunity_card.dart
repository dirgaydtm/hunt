import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/opportunity_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'category_tag.dart';
import 'opportunity_image.dart';

class OpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final bool plain;

  const OpportunityCard(this.opportunity, {super.key, this.plain = false});

  TextStyle _ts(double size, Color color, [FontWeight? weight]) => TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: size,
    fontWeight: weight,
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    final o = opportunity;
    final theme = categoryTheme(o.category);
    final urgency = plain ? null : o.urgencyText();
    final date = plain ? o.dateRange : null;

    return GestureDetector(
      onTap: () => context.push('/opportunity/${o.id}', extra: o),
      child: Container(
        padding: .symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: plain ? Colors.transparent : theme.light,
          borderRadius: .circular(24),
          border: .all(color: theme.border),
          boxShadow: plain
              ? null
              : [
                  BoxShadow(
                    color: theme.normal.withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Row(
          spacing: 24,
          children: [
            o.imagePath == null
                ? Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.light,
                      shape: .circle,
                    ),
                    child: Icon(switch (o.category.toLowerCase()) {
                      'beasiswa' => Icons.school,
                      'lomba' => Icons.emoji_events,
                      _ => Icons.business,
                    }, color: theme.normal),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: .circular(10),
                      border: .all(color: AppColors.greyLightNormal),
                    ),
                    child: ClipRRect(
                      borderRadius: .circular(9),
                      child: Image(
                        image: opportunityImage(o.imagePath!),
                        fit: .cover,
                      ),
                    ),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      CategoryTag(category: o.category),
                      if (urgency != null)
                        Container(
                          padding: .symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.orangeLight,
                            border: .all(color: AppColors.orangeNormal),
                            borderRadius: .circular(48),
                          ),
                          child: Text(
                            urgency,
                            style: _ts(
                              8,
                              AppColors.orangeNormal,
                              AppFontWeight.semiBold,
                            ),
                          ),
                        ),
                      Spacer(),
                      if (date != null)
                        Text(
                          date,
                          style: _ts(10, AppColors.greyLightDarkActive),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    o.title,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: _ts(
                      12,
                      AppColors.greyDarkNormal,
                      AppFontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    o.organizer,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: _ts(10, AppColors.greyLightDarkActive),
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
