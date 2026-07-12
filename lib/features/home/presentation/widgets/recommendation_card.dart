import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/category_tag.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String organizer;
  final String category;
  final String? postedAt;
  final String? imagePath;
  final VoidCallback? onTap;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.organizer,
    required this.category,
    this.postedAt,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = CategoryTheme.getTheme(category).normal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: .only(right: 9),
        child: ClipRRect(
          borderRadius: .circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: imagePath != null
                    ? Image.asset(imagePath!, fit: BoxFit.cover)
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryTag(category: category),
                    Spacer(),
                    Text(
                      postedAt != null ? '$organizer | $postedAt' : organizer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 8,
                        fontWeight: AppFontWeight.regular,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
