/// كيان إحصائيات لوحة المسمعة (عدد الطالبات، الإنجاز الجماعي، النشيطات)
class DashboardStatsEntity {
  const DashboardStatsEntity({
    required this.totalStudents,
    required this.groupAchievementParts,
    required this.activeStudents,
  });

  final int totalStudents;
  final int groupAchievementParts;
  final int activeStudents;
}
