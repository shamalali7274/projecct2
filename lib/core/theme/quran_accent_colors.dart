import 'package:flutter/material.dart';

/// أنواع تظليل الكلمة أثناء التسميع — نفس المفهوم التقليدي بالتعليم
/// القرآني لتمييز أنواع الملاحظات (تجويد صحيح/خطأ/نسيان/ملاحظة عامة).
/// الألوان هنا تظليل دلالي فقط (Semantic) ولا تُغيّر هوية التطبيق —
/// باقي صفحة القرآن تستخدم AppColors العادية بنفس روح المشروع.
enum WordHighlightColor { none, green, red, blue, yellow }

extension WordHighlightColorX on WordHighlightColor {
  Color background(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case WordHighlightColor.none:
        return Colors.transparent;
      case WordHighlightColor.green:
        return isDark ? const Color(0xFF14532D) : const Color(0xFFD1FAE5);
      case WordHighlightColor.red:
        return isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
      case WordHighlightColor.blue:
        return isDark ? const Color(0xFF1E3A5F) : const Color(0xFFDBEAFE);
      case WordHighlightColor.yellow:
        return isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7);
    }
  }

  String get label {
    switch (this) {
      case WordHighlightColor.none:
        return 'بدون تظليل';
      case WordHighlightColor.green:
        return 'تجويد صحيح';
      case WordHighlightColor.red:
        return 'خطأ';
      case WordHighlightColor.blue:
        return 'نسيان / تلعثم';
      case WordHighlightColor.yellow:
        return 'ملاحظة';
    }
  }
}
