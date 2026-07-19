import '../../../../core/theme/quran_accent_colors.dart';

/// كلمة واحدة قابلة للتظليل ضمن نص التسميع.
/// highlight مو final عمداً لأنها بتتغيّر محلياً لحظة الضغط، وستُستبدل
/// لاحقاً بحالة تُدار عبر Bloc عند الربط الفعلي مع الباك ايند.
class QuranWordEntity {
  QuranWordEntity({
    required this.id,
    required this.text,
    this.highlight = WordHighlightColor.none,
  });

  final String id;
  final String text;
  WordHighlightColor highlight;
}
