import 'quran_word_entity.dart';

/// سطر واحد ضمن صفحة مصحف — مطابق لجدول quran_pages بالباك ايند
/// (line_number/line_type/is_centered/surah_number) مع كلماته الفعلية
/// (quran_words) المرفقة معه جاهزة من QuranPageService.
class QuranLineEntity {
  const QuranLineEntity({
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
    required this.words,
  });

  factory QuranLineEntity.fromJson(Map<String, dynamic> json) {
    final wordsJson = (json['words'] as List<dynamic>?) ?? const [];
    return QuranLineEntity(
      lineNumber: (json['line_number'] as num?)?.toInt() ?? 0,
      lineType: json['line_type'] as String? ?? '',
      isCentered: json['is_centered'] as bool? ?? false,
      surahNumber: (json['surah_number'] as num?)?.toInt() ?? 0,
      words: wordsJson.map((w) => QuranWordEntity.fromJson(w as Map<String, dynamic>)).toList(),
    );
  }

  final int lineNumber;
  final String lineType;
  final bool isCentered;
  final int surahNumber;
  final List<QuranWordEntity> words;
}
