/// جلسة تسميع واحدة — مطابقة لجدول recitation_sessions بالباك ايند.
/// status الممكنة: upcoming (لسا ما صار تسميعها) / accepted / rejected / excused.
class RecitationSessionEntity {
  const RecitationSessionEntity({
    required this.id,
    required this.studentId,
    required this.fromPage,
    required this.toPage,
    required this.status,
    this.scheduledDate,
    this.reviewedAt,
    this.isSmartReview = false,
  });

  factory RecitationSessionEntity.fromJson(Map<String, dynamic> json) {
    return RecitationSessionEntity(
      id: (json['id'] as num).toInt(),
      studentId: (json['student_id'] as num?)?.toInt() ?? 0,
      fromPage: (json['from_page'] as num).toInt(),
      toPage: (json['to_page'] as num).toInt(),
      status: json['status'] as String? ?? 'upcoming',
      scheduledDate: json['scheduled_date'] as String?,
      reviewedAt: json['reviewed_at'] as String?,
      // غايب بالكامل لو الباك ايند القديم (قبل إضافة عمود
      // is_smart_review) لسا شغال - يعتبر تسميع عادي بشكل افتراضي.
      // تحمّل bool أو int (1/0) - MySQL أحياناً بيرجع tinyint كـ int
      // بالـ JSON لو الموديل ما فيه cast صريح لـ boolean، فما بنكسر
      // الشاشة كاملة إذا صار هيك بالمستقبل بحقل جديد مشابه.
      isSmartReview: switch (json['is_smart_review']) {
        bool v => v,
        int v => v != 0,
        _ => false,
      },
    );
  }

  final int id;
  final int studentId;
  final int fromPage;
  final int toPage;
  final String status;
  final String? scheduledDate;
  final String? reviewedAt;
  final bool isSmartReview;

  String get statusLabel {
    switch (status) {
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'غير مقبول';
      case 'excused':
        return 'معذورة';
      case 'upcoming':
      default:
        return 'قادم';
    }
  }

  String get pagesLabel =>
      fromPage == toPage ? 'صفحة $fromPage' : 'الصفحات $fromPage - $toPage';
}
