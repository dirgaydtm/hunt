import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HuntTextField extends StatefulWidget {
  final String? label;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const HuntTextField({
    super.key,
    this.label,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  State<HuntTextField> createState() => _HuntTextFieldState();
}

class _HuntTextFieldState extends State<HuntTextField> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              fontWeight: AppFontWeight.bold,
              color: AppColors.greyDarkDark,
            ),
          ),
          SizedBox(height: 12),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: _hasError
                ? []
                : const [
                    BoxShadow(
                      color: Color(0x3F00A9B8),
                      blurRadius: 8,
                      offset: Offset.zero,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            validator: (value) {
              final error = widget.validator?.call(value);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                if (_hasError != (error != null)) {
                  setState(() {
                    _hasError = error != null;
                  });
                }
              });

              return error;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                fontWeight: AppFontWeight.regular,
                color: AppColors.greyLightDark,
              ),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(left: 24, right: 12),
                      child: Icon(
                        widget.prefixIcon,
                        size: 16,
                        color: AppColors.greyLightDark,
                      ),
                    ),
              suffixIcon: widget.suffixIcon == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(left: 12, right: 24),
                      child: widget.suffixIcon,
                    ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: AppColors.blueNormal,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: AppColors.redNormal,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: AppColors.redNormal,
                  width: 2,
                ),
              ),
              errorStyle: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.redNormal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
