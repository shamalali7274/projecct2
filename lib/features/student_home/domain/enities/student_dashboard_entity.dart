/// تجميع بيانات لوحة الطالبة الرئيسية من الـ 5 endpoints سوا،
/// لأنها كلها بتتحمّل مرة وحدة لعرض شاشة وحدة (نفس فكرة
/// DashboardStatsEntity بميزة dashboard تبع المعلّمة).
///
/// ملاحظة: الباك اند (StudentsController) بيرجّع رقم الترتيب فقط
/// (مثلاً ranking: 12) بلا "من كم طالبة إجمالاً" — لهيك ما في
/// totalStudents هون، والواجهة رح تعرض الرقم لحاله بدل "١٢ من ١٢٠٠".
class StudentDashboardEntity {
  const StudentDashboardEntity({
    required this.id,
    required this.fullName,
    required this.goal,
    required this.path,
    required this.college,
    required this.achievement,
    required this.ranking,
    required this.collegeRanking,
    required this.pathRanking,
  });

  /// Student.id — صار متوفر حديثاً بـ GET /students/info (id) بعد ما
  /// عدّل الباك ايند. هاد بالضبط الرقم يلي كان ناقص لربط
  /// GET /students/{id}/recitation-history وGET /students/{id}/next-session
  /// من جانب الطالبة نفسها.
  final int id;
  final String fullName;
  final int goal;
  final String path;
  final String college;
  final int achievement;
  final int ranking;
  final int collegeRanking;
  final int pathRanking;

  /// نسبة الإنجاز بالنسبة للهدف (goal) — مطابقة لحلقة التقدم بالـ HTML.
  int get progressPercent {
    if (goal <= 0) return 0;
    return ((achievement / goal) * 100).clamp(0, 100).round();
  }
}
