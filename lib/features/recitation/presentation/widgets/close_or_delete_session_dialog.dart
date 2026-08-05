import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';

/// نتيجة اختيار الأنسة من حوار "إلغاء": إغلاق فقط (الجلسة تضل
/// upcoming، قابلة للاستئناف لاحقاً) أو حذف نهائي (تُحذف الجلسة من
/// الداتابيس، ما بتظهر بالسجل إطلاقاً).
enum CloseOrDeleteChoice { close, delete }

/// حوار مشترك بين صفحة التسميع العادي وصفحة السبر الذكي - نفس السلوك
/// المطلوب بالاثنين بالضبط: زر "إلغاء" وحيد بيفتح هاد الحوار، وبعدين
/// الأنسة تختار "إغلاق فقط" أو "حذف الجلسة نهائياً"، أو تتراجع
/// وترجع لنفس الشاشة بدون أي إجراء.
Future<CloseOrDeleteChoice?> showCloseOrDeleteSessionDialog(
  BuildContext context, {
  required String sessionLabel,
}) {
  final scheme = Theme.of(context).colorScheme;
  return showDialog<CloseOrDeleteChoice>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('إلغاء الجلسة'),
      content: Text(
        'شو حابة تعملي بـ"$sessionLabel"؟\n\n'
        '• إغلاق فقط: بتقدري ترجعي تفوتي عليها وتكمليها لاحقاً.\n'
        '• حذف نهائياً: بتنحذف كلياً وما رح تظهر بالسجل إطلاقاً.',
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('تراجع'),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(CloseOrDeleteChoice.delete),
              style: TextButton.styleFrom(foregroundColor: scheme.error),
              child: const Text('حذف نهائياً'),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(CloseOrDeleteChoice.close),
              child: const Text('إغلاق فقط'),
            ),
          ],
        ),
      ],
    ),
  );
}
