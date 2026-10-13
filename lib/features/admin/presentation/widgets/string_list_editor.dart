import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Editable list of single-line strings (syarat, berkas, ketentuan).
class StringListEditor extends StatefulWidget {
  final String label;
  final List<String> initial;
  final ValueChanged<List<String>> onChanged;

  const StringListEditor({
    super.key,
    required this.label,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<StringListEditor> createState() => _StringListEditorState();
}

class _StringListEditorState extends State<StringListEditor> {
  late final List<TextEditingController> _controllers = widget.initial
      .map((v) => TextEditingController(text: v))
      .toList();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _emit() => widget.onChanged(
    _controllers.map((c) => c.text.trim()).where((v) => v.isNotEmpty).toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: AppFontWeight.bold,
                  color: AppColors.blueDarkActive,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () =>
                  setState(() => _controllers.add(TextEditingController())),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah'),
            ),
          ],
        ),
        for (final (i, c) in _controllers.indexed)
          Padding(
            padding: const .only(bottom: 8),
            child: Row(
              children: [
                Text('${i + 1}.'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: c,
                    minLines: 1,
                    maxLines: 3,
                    onChanged: (_) => _emit(),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.redNormal,
                  onPressed: () {
                    setState(() => _controllers.removeAt(i).dispose());
                    _emit();
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
