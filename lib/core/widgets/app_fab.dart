import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// زر عائم موحّد (Extended FAB) قابل لإعادة الاستخدام في أي صفحة.
class AppFab extends StatelessWidget {
  const AppFab({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.primary,
      borderRadius: BorderRadius.circular(AppRadius.full),
      elevation: 6,
      shadowColor: scheme.primary.withOpacity(0.3),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: scheme.onPrimary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
