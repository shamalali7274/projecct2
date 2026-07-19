import 'package:flutter/material.dart';

/// ألوان "بلاطات" ناعمة (Pastel Tiles) — نفس روح المرجع اللي بعتيه
/// (ألوان هادئة فاتحة لكل بطاقة)، لكن مشتقة من هوية المشروع نفسها
/// (الأخضر/الذهبي/الوردي الموجودين أصلاً بـ AppColors) بدل اختراع
/// نظام ألوان جديد بالكامل — فيضل الشكل "من نفس الروح" متل ما طلبتي.
enum PastelTile { sage, rose, sand, lavender }

/// يرجّع تدرّج ألوان دوري حسب ترتيب العنصر بقائمة (طالبة رقم 0 تاخد
/// أول لون، رقم 1 اللي بعده...) بدل ما كل الصفحة تصير بلون واحد.
PastelTile pastelTileForIndex(int index) => PastelTile.values[index % PastelTile.values.length];

extension PastelTileX on PastelTile {
  Color background(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case PastelTile.sage:
        return isDark ? const Color(0xFF1E3226) : const Color(0xFFDCEFE1);
      case PastelTile.rose:
        return isDark ? const Color(0xFF33232A) : const Color(0xFFF6E1E7);
      case PastelTile.sand:
        return isDark ? const Color(0xFF332B1C) : const Color(0xFFF6EBD8);
      case PastelTile.lavender:
        return isDark ? const Color(0xFF272233) : const Color(0xFFE9E3F3);
    }
  }

  Color foreground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case PastelTile.sage:
        return isDark ? const Color(0xFF9CD3A7) : const Color(0xFF1C502F);
      case PastelTile.rose:
        return isDark ? const Color(0xFFD7C1C9) : const Color(0xFF6F5E65);
      case PastelTile.sand:
        return isDark ? const Color(0xFFE9C176) : const Color(0xFF7A5B12);
      case PastelTile.lavender:
        return isDark ? const Color(0xFFC7B9E0) : const Color(0xFF564A73);
    }
  }
}
