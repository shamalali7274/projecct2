import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/confirm_action_dialog.dart';
import '../../../../core/theme/app_dimensions.dart';

/// شريط الإجراءات أسفل صفحة التسميع: قبول / عدم قبول / إلغاء.
/// كل زر يفتح نفس نافذة التأكيد الموحّدة (ConfirmActionDialog) باسم
/// العملية المناسب قبل التنفيذ الفعلي.
class RecitationActionBar extends StatelessWidget {
  const RecitationActionBar({
    super.key,
    required this.onAccepted,
    required this.onRejected,
    required this.onCancelled,
  });

  final VoidCallback onAccepted;
  final VoidCallback onRejected;
  final VoidCallback onCancelled;

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required ConfirmActionSentiment sentiment,
    required VoidCallback onConfirmed,
  }) async {
    final confirmed = await showConfirmActionDialog(
      context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      sentiment: sentiment,
    );
    if (confirmed) onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(color: scheme.onSurface.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, -8)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'إلغاء',
                variant: AppButtonVariant.outlined,
                height: 52,
                onPressed: () => _confirm(
                  context,
                  title: 'إلغاء التسميع',
                  message: 'هل أنتِ متأكدة من إلغاء جلسة التسميع الحالية؟',
                  confirmLabel: 'تأكيد الإلغاء',
                  sentiment: ConfirmActionSentiment.neutral,
                  onConfirmed: onCancelled,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: 'غير مقبول',
                variant: AppButtonVariant.filled,
                height: 52,
                onPressed: () => _confirm(
                  context,
                  title: 'تسميع غير مقبول',
                  message: 'هل أنتِ متأكدة من تسجيل هذا التسميع كغير مقبول؟',
                  confirmLabel: 'تأكيد',
                  sentiment: ConfirmActionSentiment.negative,
                  onConfirmed: onRejected,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: 'مقبول',
                height: 52,
                onPressed: () => _confirm(
                  context,
                  title: 'تسميع مقبول',
                  message: 'هل أنتِ متأكدة من قبول هذا التسميع؟',
                  confirmLabel: 'تأكيد',
                  sentiment: ConfirmActionSentiment.positive,
                  onConfirmed: onAccepted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
