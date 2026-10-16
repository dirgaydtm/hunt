import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/opportunity_model.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/category_tag.dart';
import '../../../../core/widgets/opportunity_image.dart';

class RecommendationCard extends StatelessWidget {
  final OpportunityModel opportunity;

  const RecommendationCard(this.opportunity, {super.key});

  @override
  Widget build(BuildContext context) {
    final o = opportunity;
    final catColor = categoryTheme(o.category).normal;
    final postedAt = o.postedAt();

    return GestureDetector(
      onTap: () => context.push('/opportunity/${o.id}', extra: o),
      child: Container(
        width: 170,
        margin: .only(right: 9),
        child: ClipRRect(
          borderRadius: .circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: o.imagePath != null
                    ? Image(image: opportunityImage(o.imagePath!), fit: .cover)
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: .topLeft,
                            end: .bottomRight,
                            colors: [catColor, catColor.withValues(alpha: 0.6)],
                          ),
                        ),
                      ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topCenter,
                      end: .bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: .all(12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CategoryTag(category: o.category),
                    Spacer(),
                    Text(
                      postedAt != null
                          ? '${o.organizer} | $postedAt'
                          : o.organizer,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 8,
                        fontWeight: AppFontWeight.regular,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      o.title,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12,
                        fontWeight: AppFontWeight.extraBold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
