import '../../../../core/theme/quran_accent_colors.dart';

/// كلمة واحدة ضمن نص التسميع — مطابقة تماماً لحقول quran_words
/// بالباك ايند (QuranPageService::getPages): word_id/surah/ayah/position/text.
/// wordId/surah/ayah لازمين لإرسال الأخطاء لاحقاً بـ
/// POST /recitation-sessions/{id}/errors بنفس الشكل اللي يتوقعه الباك ايند.
class QuranWordEntity {
  QuranWordEntity({
    required this.wordId,
    required this.surah,
    required this.ayah,
    required this.position,
    required this.text,
    this.highlight = WordHighlightColor.none,
  });

  factory QuranWordEntity.fromJson(Map<String, dynamic> json) {
    return QuranWordEntity(
      wordId: (json['word_id'] as num).toInt(),
      surah: (json['surah'] as num).toInt(),
      ayah: (json['ayah'] as num).toInt(),
      position: (json['position'] as num?)?.toInt() ?? 0,
      text: json['text'] as String? ?? '',
    );
  }

  final int wordId;
  final int surah;
  final int ayah;
  final int position;
  final String text;

  /// مو final عمداً: تتغيّر محلياً لحظة الضغط أثناء التسميع (وضع
  /// الأنسة القابل للتعديل)، وتضل ثابتة (readOnly) بجانب الطالبة.
  WordHighlightColor highlight;
}
