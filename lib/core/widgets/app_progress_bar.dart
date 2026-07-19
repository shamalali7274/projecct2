import 'package:flutter/material.dart';

/// شريط تقدّم موحّد يعرض التسمية والنسبة المئوية معاً.
/// يُستخدم داخل بطاقة الطالبة، وقابل لإعادة الاستخدام في أي مكان آخر
/// يحتاج لعرض نسبة تقدّم (مثل صفحة تفاصيل الطالبة لاحقاً).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progressLabel,
    required this.percentage,
  });

  /// النسبة كرقم بين 0 و 1
  final String progressLabel;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final clamped = percentage.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(progressLabel, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
            Text(
              '${(clamped * 100).round()}٪',
              style: textTheme.bodySmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: 8,
            backgroundColor: scheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation(scheme.primary),
          ),
        ),
      ],
    );
  }
}
