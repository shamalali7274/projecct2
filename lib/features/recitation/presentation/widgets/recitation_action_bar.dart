import 'package:flutter/material.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/confirm_action_dialog.dart';
import '../../../../core/theme/app_dimensions.dart';

/// شريط الإجراءات أسفل صفحة التسميع: غير مقبول / مقبول / إلغاء —
/// بشكل الأزرار الدائرية المطابق للتصميم المرجعي، مبني من CircleIconButton
/// الموحّد (نفس الزر، ثلاث استدعاءات بأحجام وألوان مختلفة) بدل تكرار
/// كود الزر ثلاث مرات.
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: scheme.onSurface.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // بترتيب RTL: أول عنصر بالكود = أقصى اليمين على الشاشة.
            CircleIconButton(
              icon: Icons.thumb_down_alt_rounded,
              label: 'غير مقبول',
              backgroundColor: scheme.errorContainer,
              iconColor: scheme.onErrorContainer,
              size: 56,
              iconSize: 22,
              onTap: () => _confirm(
                context,
                title: 'تسميع غير مقبول',
                message: 'هل أنتِ متأكدة من تسجيل هذا التسميع كغير مقبول؟',
                confirmLabel: 'تأكيد',
                sentiment: ConfirmActionSentiment.negative,
                onConfirmed: onRejected,
              ),
            ),
            CircleIconButton(
              icon: Icons.check_rounded,
              label: 'مقبول',
              backgroundColor: scheme.primary,
              iconColor: scheme.onPrimary,
              size: 76,
              iconSize: 32,
              glow: true,
              labelColor: scheme.primary,
              onTap: () => _confirm(
                context,
                title: 'تسميع مقبول',
                message: 'هل أنتِ متأكدة من قبول هذا التسميع؟',
                confirmLabel: 'تأكيد',
                sentiment: ConfirmActionSentiment.positive,
                onConfirmed: onAccepted,
              ),
            ),
            CircleIconButton(
              icon: Icons.close_rounded,
              label: 'إلغاء',
              backgroundColor: scheme.surfaceContainerHigh,
              iconColor: scheme.onSurfaceVariant,
              size: 56,
              iconSize: 22,
              onTap: () => _confirm(
                context,
                title: 'إلغاء التسميع',
                message: 'هل أنتِ متأكدة من إلغاء جلسة التسميع الحالية؟',
                confirmLabel: 'تأكيد الإلغاء',
                sentiment: ConfirmActionSentiment.neutral,
                onConfirmed: onCancelled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
