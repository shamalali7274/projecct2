import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/masar_option.dart';

/// اختيار المسار (بطاقتين قابلتين للاختيار: زاد / أترجة)، خاص بصفحة
/// إنشاء الحساب.

class MasarSelector extends StatelessWidget {
  const MasarSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final MasarOption selected;
  final ValueChanged<MasarOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('المسار', style: textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (int i = 0; i < MasarOption.values.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MasarCard(
                  option: MasarOption.values[i],
                  isSelected: MasarOption.values[i] == selected,
                  onTap: () => onChanged(MasarOption.values[i]),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MasarCard extends StatelessWidget {
  const _MasarCard({required this.option, required this.isSelected, required this.onTap});

  final MasarOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary.withOpacity(0.05) : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? scheme.primary : scheme.outlineVariant.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}