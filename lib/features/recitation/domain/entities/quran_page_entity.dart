import 'quran_line_entity.dart';

/// صفحة واحدة من صفحات المصحف بأسطرها الحقيقية (QuranPageService)،
/// جزء من جلسة تسميع (RecitationSessionEntity) واحدة قد تمتد لأكتر
/// من صفحة (from_page → to_page).
class QuranPageEntity {
  const QuranPageEntity({required this.pageNumber, required this.lines});

  final int pageNumber;
  final List<QuranLineEntity> lines;

  /// يبني قائمة صفحات مرتبة من استجابة GET /students/{id}/next-session
  /// اللي شكلها { "293": [line, line, ...], "294": [...] } — مفاتيح
  /// الـ Map هون أرقام الصفحات كنص (JSON keys دايماً نصوص).
  static List<QuranPageEntity> listFromPagesJson(Map<String, dynamic> pagesJson) {
    final pageNumbers = pagesJson.keys.map(int.parse).toList()..sort();
    return pageNumbers.map((pageNumber) {
      final linesJson = (pagesJson[pageNumber.toString()] as List<dynamic>?) ?? const [];
      return QuranPageEntity(
        pageNumber: pageNumber,
        lines: linesJson
            .map((l) => QuranLineEntity.fromJson(l as Map<String, dynamic>))
            .toList(),
      );
    }).toList();
  }
}
