import 'package:flutter/material.dart';
import '../data/repositories/smart_recitation_repository.dart';
import '../domain/entities/smart_recitation_session_bundle.dart';
import 'pages/smart_recitation_session_page.dart';
import 'widgets/smart_recitation_setup_sheet.dart';

/// نقطة الدخول لميزة السبر الذكي:
/// 1) نتحقق أول شي إذا في جلسة سبر "upcoming" لهاي الطالبة أصلاً
///    (يعني الانسة بلشت سبر وما خلصته/ألغته بمنتصف الطريق) - إذا في،
///    منروح عليها مباشرة بنفس أسئلتها المجمّدة (استئناف)، بدون ما
///    نسألها المجال والعدد من جديد.
/// 2) إذا ما في، منفتح شاشة الإعداد (من صفحة/إلى صفحة/كم سؤال) ومنبني
///    جلسة جديدة.
Future<void> startSmartRecitation(
  BuildContext context, {
  required int studentId,
  required String studentName,
}) async {
  final repository = SmartRecitationRepository();

  SmartRecitationSessionBundle? bundle;
  try {
    bundle = await repository.getUpcoming(studentId);
  } catch (_) {
    bundle = null; // تعذّر التحقق - منكمل عادي بفتح شاشة إعداد جديدة
  }

  if (bundle != null) {
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SmartRecitationSessionPage(
          studentId: studentId,
          studentName: studentName,
          initialBundle: bundle!,
        ),
      ),
    );
    return;
  }

  if (!context.mounted) return;
  final setup = await showSmartRecitationSetupSheet(context);
  if (setup == null || !context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SmartRecitationSessionPage(
        studentId: studentId,
        studentName: studentName,
        setup: setup,
      ),
    ),
  );
}
