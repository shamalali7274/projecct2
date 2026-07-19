import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/quran_accent_colors.dart';
import 'word_color_picker.dart';

/// كلمة واحدة قابلة للتظليل: نقر مزدوج يفتح قائمة الألوان (سواء كانت
/// الكلمة بدون لون أو ملوّنة فعلاً)، واختيار "إزالة اللون" من نفس
/// القائمة يشيل التظليل بدل ما يحتاج تصرّف منفصل.
class HighlightableWord extends StatelessWidget {
  const HighlightableWord({
    super.key,
    required this.text,
    required this.highlight,
    required this.onChanged,
  });

  final String text;
  final WordHighlightColor highlight;
  final ValueChanged<WordHighlightColor> onChanged;

  Future<void> _handleDoubleTap(BuildContext context) async {
    final picked = await showWordColorPicker(context);
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onDoubleTap: () => _handleDoubleTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          color: highlight.background(context),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: GoogleFonts.amiri(fontSize: 26, height: 2.0, color: scheme.onSurface),
        ),
      ),
    );
  }
}
