import 'package:flutter/material.dart';
import '../domain/entities/recitation_range_entity.dart';
import 'pages/quran_recitation_page.dart';

/// نقطة دخول موحّدة لبدء جلسة تسميع لأي طالبة، تُستدعى من أي صفحة
/// (اللوحة الرئيسية، قائمة الطالبات، أو سجل إنجازات الطالبة) بدل
/// تكرار نفس منطق التنقل وبناء نطاق التسميع بأكثر من مكان.
void startRecitationSession(BuildContext context, String studentName) {
  // TODO: هون رح نجيب نطاق التسميع الفعلي (من صفحة لصفحة) من الباك
  // ايند بدل هاد الـ Mock، بناءً على آخر نقطة وصلتها الطالبة فعلياً.
  const range = RecitationRangeEntity(surahName: 'سورة الكهف', fromPage: 293, toPage: 298);

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => QuranRecitationPage(studentName: studentName, range: range),
    ),
  );
}
