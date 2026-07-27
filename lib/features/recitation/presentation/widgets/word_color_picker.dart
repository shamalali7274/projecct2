import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/quran_accent_colors.dart';

/// قائمة اختيار لون التظليل — تظهر عند النقر المزدوج على أي كلمة.
/// ترجع اللون المختار، أو null إذا أُلغيت العملية بدون اختيار.
Future<WordHighlightColor?> showWordColorPicker(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;

  return showModalBottomSheet<WordHighlightColor>(
    context: context,
    backgroundColor: scheme.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (sheetContext) {
      const options = [
        WordHighlightColor.green,
        WordHighlightColor.red,
        WordHighlightColor.blue,
        WordHighlightColor.yellow,
      ];

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              Text('حددي نوع الملاحظة على الكلمة', style: Theme.of(sheetContext).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                alignment: WrapAlignment.center,
                children: [
                  for (final option in options)
                    _ColorSwatch(
                      color: option.background(sheetContext),
                      label: option.label,
                      onTap: () => Navigator.of(sheetContext).pop(option),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton.icon(
                onPressed: () => Navigator.of(sheetContext).pop(WordHighlightColor.none),
                icon: Icon(Icons.format_color_reset, color: scheme.outline),
                label: Text('إزالة اللون', style: TextStyle(color: scheme.outline)),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.label, required this.onTap});

  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.outlineVariant.withOpacity(0.4)),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
