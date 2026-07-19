/// نطاق التسميع القادم (من أي صفحة لأي صفحة) — تُجلب من الباك ايند
/// عند ضغط الأنسة على زر "بدء التسميع"، بناءً على آخر نقطة وصلتها
/// الطالبة.
class RecitationRangeEntity {
  const RecitationRangeEntity({
    required this.surahName,
    required this.fromPage,
    required this.toPage,
  });

  final String surahName;
  final int fromPage;
  final int toPage;
}
