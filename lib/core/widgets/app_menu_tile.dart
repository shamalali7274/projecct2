import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// صف قائمة موحّد (أيقونة + نص + سهم) يُستخدم داخل أي صفحة قوائم
/// (الإعدادات مثلاً). يُبنى مرة واحدة هون فقط، وكل صفحة بتمرّر له
/// الأيقونة/النص/اللون المناسب بدل ما تعيد بناء Row/InkWell من جديد
/// بكل مرة — نفس فكرة "بناء المستطيل مرة وحدة واستدعاؤه بأبعاد مختلفة".
class AppMenuTile extends StatelessWidget {
  const AppMenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// true لصفوف مثل "تسجيل الخروج" (تُلوَّن بلون الخطأ بدل الألوان
  /// الاعتيادية) بدل تكرار منطق الألوان بكل استدعاء.
  final bool isDestructive;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final contentColor = isDestructive ? scheme.error : scheme.onSurface;
    final iconBg = isDestructive
        ? scheme.errorContainer
        : scheme.secondaryContainer;
    final iconFg = isDestructive ? scheme.onErrorContainer : scheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: 20, color: iconFg),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: contentColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              trailing ??
                  Icon(Icons.arrow_back_ios, size: 14, color: scheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
