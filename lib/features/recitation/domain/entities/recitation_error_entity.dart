import '../../../../core/theme/quran_accent_colors.dart';

/// خطأ/ملاحظة واحدة على كلمة معيّنة — الشكل المطلوب تماماً من
/// StoreRecitationErrorsRequest بالباك ايند (word_id/surah_number/
/// ayah_number/error_type)، وerror_type لازم يكون واحد من:
/// red, blue, yellow, green (ما فيها "none" — الكلمات بدون تظليل
/// أصلاً ما بترسل ضمن القائمة).
class RecitationErrorEntity {
  const RecitationErrorEntity({
    required this.wordId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.errorType,
  });

  Map<String, dynamic> toJson() => {
    'word_id': wordId,
    'surah_number': surahNumber,
    'ayah_number': ayahNumber,
    'error_type': errorType.name, // WordHighlightColor.red.name == 'red' ...إلخ، مطابق تماماً لقيم الباك ايند
  };

  final int wordId;
  final int surahNumber;
  final int ayahNumber;
  final WordHighlightColor errorType;
}
