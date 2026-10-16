import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HuntButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? leading;

  const HuntButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final onTap = isLoading ? null : onPressed;
    final label = Row(
      mainAxisAlignment: .center,
      spacing: 12,
      children: [
        ?leading,
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: isOutlined ? 14 : 16,
            fontWeight: AppFontWeight.bold,
            color: isOutlined ? AppColors.blueNormalActive : null,
          ),
        ),
      ],
    );

    return SizedBox(
      width: isOutlined ? null : double.infinity,
      height: 52,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: AppColors.blueDark, width: 1.5),
                shape: StadiumBorder(),
              ),
              child: label,
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.blueLightActive,
                shape: StadiumBorder(),
                elevation: 0,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : label,
            ),
    );
  }
}
