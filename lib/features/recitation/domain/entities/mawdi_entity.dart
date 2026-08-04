/// موضع واحد من كتاب "التبيان المفصل لمتشابهات القرآن" — مطابق تماماً
/// لعنصر واحد جوا مصفوفة `mawadi_by_page[page]` اللي يرجعها
/// RecitationSessionController@show بعد ربط أخطاء الطالبة الحمراء
/// بجدول word_colors (استخراج الـ OCR).
///
/// `html` نص جاهز مسبقاً من مرحلة تحضير الكتاب (فيه <span
/// style="color:red">...</span> على الكلمات المتشابهة) — العرض
/// بالواجهة عبر ColoredHtmlText (core/widgets) بدل أي منطق تلوين هون.
class MawdiEntity {
  const MawdiEntity({
    required this.mawdiId,
    required this.mawdiNumber,
    required this.html,
    required this.matchedWords,
  });

  factory MawdiEntity.fromJson(Map<String, dynamic> json) {
    final wordsJson = (json['matched_words'] as List<dynamic>?) ?? const [];
    return MawdiEntity(
      mawdiId: (json['mawdi_id'] as num).toInt(),
      mawdiNumber: (json['mawdi_number'] as num?)?.toInt() ?? 0,
      html: json['html'] as String? ?? '',
      matchedWords: wordsJson.map((w) => w as String).toList(),
    );
  }

  final int mawdiId;
  final int mawdiNumber;
  final String html;
  final List<String> matchedWords;

  /// يبني Map<رقم الصفحة, مواضعها> من كائن `mawadi_by_page` الكامل
  /// اللي يرجعه POST /recitation-sessions/show — مفاتيح الـ JSON هون
  /// أرقام صفحات كنص (زي pagesJson بالضبط)، وممكن تجي غايبة بالكامل
  /// (session بدون أي خطأ أحمر مرتبط بموضع) فبيرجع Map فاضية.
  static Map<int, List<MawdiEntity>> mapFromJson(Map<String, dynamic>? mawadiByPageJson) {
    if (mawadiByPageJson == null) return const {};
    return mawadiByPageJson.map((pageKey, mawadiListJson) {
      final list = (mawadiListJson as List<dynamic>?) ?? const [];
      return MapEntry(
        int.parse(pageKey),
        list.map((m) => MawdiEntity.fromJson(m as Map<String, dynamic>)).toList(),
      );
    });
  }
}
