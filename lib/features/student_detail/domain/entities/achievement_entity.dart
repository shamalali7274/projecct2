import '../../../recitation/domain/entities/quran_page_entity.dart';

/// حالة الإنجاز — تتحكم بلون/أيقونة نقطة الخط الزمني تلقائياً.
enum AchievementStatus { excellent, goodReview, milestone }

/// إنجاز واحد بسجل تسميع الطالبة (سورة/جزء أنجزته وتاريخه وتقييمه).
class AchievementEntity {
  const AchievementEntity({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.pagesLabel,
    required this.statusLabel,
    required this.status,
    this.note,
    this.quranPages,
  });

  final String id;
  final String title;
  final String dateLabel;
  final String pagesLabel;
  final String statusLabel;
  final AchievementStatus status;
  final String? note;

  /// صفحات المصحف الخاصة بهاد التسميع بالضبط، مع تظليل الأخطاء/الملاحظات
  /// يلي حطّتها الأنسة وقتها. null أو قائمة فاضية = هاد الإنجاز ما
  /// إله صفحات قرآن مرتبطة (متل "تم إتقان الجزء ١٤" العام)، فبيصير
  /// التاب غير قابل للضغط بسجل الإنجازات.
  final List<QuranPageEntity>? quranPages;
}
