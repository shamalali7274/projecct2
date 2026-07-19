import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// حقل بحث موحّد مع زر تصفية اختياري.
/// قابل لإعادة الاستخدام في أي صفحة تحتاج بحث (الطالبات، الإنجازات...).
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onFilterTap,
    this.filterLabel = 'تصفية',
    this.onChanged,
  });

  final String hintText;
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final String filterLabel;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: [
          BoxShadow(color: scheme.onSurface.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: scheme.outline),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: scheme.onSurfaceVariant.withOpacity(0.5)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (onFilterTap != null)
            TextButton(
              onPressed: onFilterTap,
              style: TextButton.styleFrom(
                backgroundColor: scheme.secondaryContainer,
                foregroundColor: scheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
              ),
              child: Text(filterLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
