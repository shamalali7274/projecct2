import 'quran_word_entity.dart';

/// صفحة واحدة من صفحات المصحف ضمن إنجاز/تسميع معيّن — نصّها مقسّم
/// لكلمات (QuranWordEntity) وكل كلمة معها لون التظليل اللي حطّته
/// الأنسة وقت التسميع الفعلي. هاي البيانات تُقرأ فقط بجانب الطالبة
/// (read-only) — التعديل عليها من صلاحية الأنسة حصراً.
class QuranPageEntity {
  const QuranPageEntity({required this.pageNumber, required this.words});

  final int pageNumber;
  final List<QuranWordEntity> words;
}
