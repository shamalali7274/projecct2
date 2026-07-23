import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/quran_accent_colors.dart';
import 'word_color_picker.dart';

/// كلمة واحدة قابلة للتظليل: نقر مزدوج يفتح قائمة الألوان (سواء كانت
/// الكلمة بدون لون أو ملوّنة فعلاً)، واختيار "إزالة اللون" من نفس
/// القائمة يشيل التظليل بدل ما يحتاج تصرّف منفصل.
///
/// بوضع [readOnly] (تُستخدم بصفحة مراجعة الطالبة لتسميعاتها) نفس
/// الودجت بالضبط بتتعرض بس بدون أي تفاعل — بدل ما نكرر كود رسم
/// الكلمة وتلوينها بودجت منفصل لكل حالة.
class HighlightableWord extends StatelessWidget {
  const HighlightableWord({
    super.key,
    required this.text,
    required this.highlight,
    this.onChanged,
    this.readOnly = false,
  }) : assert(
         readOnly || onChanged != null,
         'onChanged مطلوب إلا إذا كانت الكلمة readOnly',
       );

  final String text;
  final WordHighlightColor highlight;
  final ValueChanged<WordHighlightColor>? onChanged;

  /// true = عرض فقط (بلا تفاعل)، تُستخدم بصفحة مراجعة الطالبة
  /// لمنعها من تعديل تصحيحات الأنسة.
  final bool readOnly;

  Future<void> _handleDoubleTap(BuildContext context) async {
    final picked = await showWordColorPicker(context);
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final word = Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: BoxDecoration(
        color: highlight.background(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.amiri(fontSize: 26, height: 2.0, color: scheme.onSurface),
      ),
    );

    if (readOnly) return word;

    return GestureDetector(onDoubleTap: () => _handleDoubleTap(context), child: word);
  }
}
