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
  });

  final String id;
  final String title;
  final String dateLabel;
  final String pagesLabel;
  final String statusLabel;
  final AchievementStatus status;
  final String? note;
}
