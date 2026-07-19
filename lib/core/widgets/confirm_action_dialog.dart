import 'package:flutter/material.dart';
import 'app_button.dart';
import '../theme/app_dimensions.dart';

/// نوع العملية لضبط لون ورمز نافذة التأكيد تلقائياً بدون تكرار.
enum ConfirmActionSentiment { positive, negative, neutral }

/// نافذة تأكيد موحّدة لأي عملية حساسة (قبول/رفض/إلغاء/حذف...).
/// تُبنى مرة واحدة وتُستدعى عبر showConfirmActionDialog من أي مكان
/// بدل تكرار AlertDialog مخصص بكل شاشة.
class ConfirmActionDialog extends StatelessWidget {
  const ConfirmActionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.sentiment = ConfirmActionSentiment.neutral,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final ConfirmActionSentiment sentiment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    late final Color bg;
    late final Color fg;
    late final IconData icon;
    switch (sentiment) {
      case ConfirmActionSentiment.positive:
        bg = scheme.primaryContainer;
        fg = scheme.onPrimaryContainer;
        icon = Icons.check_circle_outline;
        break;
      case ConfirmActionSentiment.negative:
        bg = scheme.errorContainer;
        fg = scheme.onErrorContainer;
        icon = Icons.cancel_outlined;
        break;
      case ConfirmActionSentiment.neutral:
        bg = scheme.secondaryContainer;
        fg = scheme.onSecondaryContainer;
        icon = Icons.help_outline;
        break;
    }

    return Dialog(
      backgroundColor: scheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Icon(icon, color: fg, size: 28),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'رجوع',
                    variant: AppButtonVariant.outlined,
                    height: 48,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    height: 48,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// دالة مساعدة تعرض النافذة وترجع true فقط إذا أكّدت الأنسة العملية.
Future<bool> showConfirmActionDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  ConfirmActionSentiment sentiment = ConfirmActionSentiment.neutral,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => ConfirmActionDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      sentiment: sentiment,
    ),
  );
  return result ?? false;
}
