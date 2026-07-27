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
    );
  }

  final int id;
  final int studentId;
  final int fromPage;
  final int toPage;
  final String status;
  final String? scheduledDate;
  final String? reviewedAt;

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
