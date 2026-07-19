import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// مكوّن البطاقة الأساسي القابل لإعادة الاستخدام (Reusable Surface Card).
///
/// يُبنى مرة واحدة فقط، وتُمرَّر له الأبعاد/اللون/الحواف من الخارج
/// بدل إعادة كتابة Container بنفس الخصائص في كل صفحة.
/// يطبّق مبدأ "No-Line Rule" من DESIGN.md: لا حدود صلبة، فقط
/// طبقات لونية (Tonal Layering) وظل ناعم (Ambient Shadow).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius = AppRadius.lg,
    this.backgroundColor,
    this.onTap,
    this.margin,
    this.width,
    this.height,
    this.withShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final content = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: scheme.onSurface.withOpacity(0.04),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
