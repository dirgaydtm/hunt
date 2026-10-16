import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HuntAccordion extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final List<String> items;
  final double horizontalPadding;

  const HuntAccordion({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.items,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        Divider(
          height: 1,
          color: AppColors.blueLightActive.withValues(alpha: 0.5),
        ),
        ExpansionTile(
          shape: Border(),
          collapsedShape: Border(),
          tilePadding: .symmetric(vertical: 4, horizontal: horizontalPadding),
          maintainState: true,
          iconColor: AppColors.blueDarkActive,
          collapsedIconColor: AppColors.blueDarkActive,
          title: Padding(
            padding: .symmetric(horizontal: 8),
            child: Row(
              spacing: 12,
              children: [
                Icon(leadingIcon, color: AppColors.blueDarkActive, size: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.blueDarkActive,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: .only(bottom: 16),
              child: Column(
                children: [
                  for (final item in items) _AccordionItem(item: item),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AccordionItem extends StatefulWidget {
  final String item;
  const _AccordionItem({required this.item});

  @override
  State<_AccordionItem> createState() => _AccordionItemState();
}

class _AccordionItemState extends State<_AccordionItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isChecked = !_isChecked),
      child: Container(
        margin: .only(bottom: 8),
        padding: .all(16),
        decoration: BoxDecoration(
          color: _isChecked ? AppColors.blueLightHover : Colors.white,
          borderRadius: .circular(12),
          border: .all(
            color: _isChecked
                ? AppColors.blueNormal
                : AppColors.blueLightActive,
          ),
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Container(
              margin: .only(top: 2),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _isChecked ? AppColors.blueNormal : Colors.white,
                borderRadius: .circular(4),
                border: .all(color: AppColors.blueNormal, width: 1.5),
              ),
              child: _isChecked
                  ? Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.item,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12,
                  color: AppColors.greyDarkNormal,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
