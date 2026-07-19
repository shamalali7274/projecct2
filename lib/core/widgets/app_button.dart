import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// أنماط الزر المتاحة لإعادة الاستخدام بدل بناء زر جديد لكل حالة
enum AppButtonVariant { primaryGradient, filled, outlined, text }

/// زر موحّد يُستخدم في كل أنحاء التطبيق.
///
/// يدعم حالة التحميل (isLoading) بشكل جاهز حتى تكون متوافقة مباشرة
/// مع حالات BLoC (loading/success/failure) عند الربط مع الباك ايند لاحقاً.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primaryGradient,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 56,
    this.borderRadius = AppRadius.full,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = _foregroundColor(scheme);
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.bold,
        );

    final Widget child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(child: Text(label, style: textStyle, overflow: TextOverflow.ellipsis)),
            ],
          );

    final BoxDecoration decoration = switch (variant) {
      AppButtonVariant.primaryGradient => BoxDecoration(
          gradient: LinearGradient(
            colors: [scheme.primary, scheme.primaryContainer],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withOpacity(0.2),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      AppButtonVariant.filled => BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      AppButtonVariant.outlined => BoxDecoration(
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.4), width: 1.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      AppButtonVariant.text => const BoxDecoration(),
    };

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: decoration,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }

  Color _foregroundColor(ColorScheme scheme) {
    switch (variant) {
      case AppButtonVariant.primaryGradient:
        return scheme.onPrimary;
      case AppButtonVariant.filled:
        return scheme.onSecondaryContainer;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        return scheme.primary;
    }
  }
}
