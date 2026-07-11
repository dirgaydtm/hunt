import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingButton extends StatelessWidget {
  final bool isLastPage;
  final double progress;
  final VoidCallback onTap;

  const OnboardingButton({
    super.key,
    required this.isLastPage,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLastPage) {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: .circular(30),
          border: Border.all(color: AppColors.blueLightActive, width: 3),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: .circular(26),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.blueNormal,
                borderRadius: .circular(26),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: .center,
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3.0,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.blueNormal),
              backgroundColor: AppColors.blueLightActive.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(
            width: 44,
            height: 44,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: .zero,
                backgroundColor: AppColors.blueNormal,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: Icon(Icons.chevron_right, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
