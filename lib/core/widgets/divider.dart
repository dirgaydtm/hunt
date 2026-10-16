import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HuntDivider extends StatelessWidget {
  final String text;

  const HuntDivider({super.key, this.text = 'atau'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.greyLightNormalActive, thickness: 1),
        ),
        Padding(
          padding: .symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              color: AppColors.blueNormal,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.greyLightNormalActive, thickness: 1),
        ),
      ],
    );
  }
}
