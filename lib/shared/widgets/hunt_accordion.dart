import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HuntAccordion extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final List<String> items;

  const HuntAccordion({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          color: AppColors.blueLightActive.withValues(alpha: 0.5),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(vertical: 4),
            maintainState: true,
            iconColor: AppColors.blueDarkActive,
            collapsedIconColor: AppColors.blueDarkActive,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  Icon(leadingIcon, color: AppColors.blueDarkActive, size: 16),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
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
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: items.map((item) {
                    return _AccordionItem(item: item);
                  }).toList(),
                ),
              ),
            ],
          ),
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
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isChecked ? AppColors.blueLightHover : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isChecked
                ? AppColors.blueNormal
                : AppColors.blueLightActive,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _isChecked ? AppColors.blueNormal : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.blueNormal, width: 1.5),
              ),
              child: _isChecked
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.item,
                style: const TextStyle(
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
