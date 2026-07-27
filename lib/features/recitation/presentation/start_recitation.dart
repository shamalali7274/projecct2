import 'package:flutter/material.dart';
import 'pages/quran_recitation_page.dart';

/// نقطة دخول موحّدة لبدء/فتح جلسة تسميع لأي طالبة، تُستدعى من أي صفحة
/// (اللوحة الرئيسية، قائمة الطالبات، أو سجل إنجازات الطالبة) بدل تكرار
/// نفس منطق التنقل. صفحة القرآن نفسها هي اللي بتجيب الجلسة القادمة
/// (أو تفتح لك إنشاء جلسة جديدة لو ما في وحدة مجدولة) من الباك ايند.
void startRecitationSession(BuildContext context, {required int studentId, required String studentName}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => QuranRecitationPage(studentId: studentId, studentName: studentName),
    ),
  );
}
