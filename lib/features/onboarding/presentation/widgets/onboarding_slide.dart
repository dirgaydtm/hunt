import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingSlide extends StatelessWidget {
  final ({String image, String title, String subtitle}) slide;
  const OnboardingSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Spacer(flex: 1),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(slide.image, fit: BoxFit.contain),
          ),
          SizedBox(height: 56),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 29,
              fontWeight: AppFontWeight.extraBold,
              color: AppColors.blueDarker,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              fontWeight: AppFontWeight.regular,
              color: AppColors.blueDarker,
              height: 1.35,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
