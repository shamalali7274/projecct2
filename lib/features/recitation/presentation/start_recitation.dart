import 'package:flutter/material.dart';
import 'pages/quran_recitation_page.dart';


Future<void> startRecitationSession(
  BuildContext context, {
  required int studentId,
  required String studentName,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => QuranRecitationPage(studentId: studentId, studentName: studentName),
    ),
  );
}