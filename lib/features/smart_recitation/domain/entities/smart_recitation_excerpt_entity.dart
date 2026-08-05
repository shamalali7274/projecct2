import '../../../recitation/domain/entities/quran_line_entity.dart';

/// سؤال سبر واحد مقترح من الباك ايند (SmartRecitationController@suggest) —
/// مقطع ~15 سطر حول أعلى نقطة أخطاء، بنصه الفعلي جاهز للعرض.
///
/// [lines] بنفس شكل QuranLineEntity تماماً (نفس المفاتيح اللي يرجعها
/// ExcerptTextRenderer بالباك ايند: line_number/line_type/is_centered/
/// surah_number/words)، فمفيش داعي لأي تحويل إضافي - نفس الـ entity
/// المستخدمة أصلاً بصفحة التسميع العادية.
class SmartRecitationExcerptEntity {
  const SmartRecitationExcerptEntity({
    required this.fromWordId,
    required this.toWordId,
    required this.fromPage,
    required this.toPage,
    required this.fromLine,
    required this.toLine,
    required this.score,
    required this.dominantCategory,
    required this.dominantCategoryLabel,
    required this.categoryBreakdown,
    required this.lines,
    required this.isRandom,
    // this.isRandom = false, // ✅ إما تعطيه قيمة افتراضية
    // أو required this.isRandom,
  });

  factory SmartRecitationExcerptEntity.fromJson(Map<String, dynamic> json) {
    final linesJson = (json['lines'] as List<dynamic>?) ?? const [];
    final breakdownJson = (json['category_breakdown'] as Map<String, dynamic>?) ?? const {};

    return SmartRecitationExcerptEntity(
      fromWordId: (json['from_word_id'] as num).toInt(),
      toWordId: (json['to_word_id'] as num).toInt(),
      fromPage: (json['from_page'] as num).toInt(),
      toPage: (json['to_page'] as num).toInt(),
      fromLine: (json['from_line'] as num).toInt(),
      toLine: (json['to_line'] as num).toInt(),
      score: (json['score'] as num?)?.toDouble() ?? 0,
      dominantCategory: json['dominant_category'] as String? ?? '',
      dominantCategoryLabel: json['dominant_category_label'] as String? ?? '',
      categoryBreakdown: breakdownJson.map((k, v) => MapEntry(k, (v as num).toInt())),
      isRandom: json['is_random'] as bool? ?? false,
      lines: linesJson
          .map((l) => QuranLineEntity.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }

  final int fromWordId;
  final int toWordId;
  final int fromPage;
  final int toPage;
  final int fromLine;
  final int toLine;
  final double score;
  final String dominantCategory;
  final String dominantCategoryLabel;
  final Map<String, int> categoryBreakdown;

  /// true = هاد السؤال "موضع عشوائي" (ما في أخطاء مسجّلة كافية عليه)
  /// بدل ما يكون مبني فعلياً على أخطاء سابقة للطالبة.
  final bool isRandom;
  final List<QuranLineEntity> lines;

  String get pagesLabel => fromPage == toPage ? 'صفحة $fromPage' : 'الصفحات $fromPage - $toPage';
}
