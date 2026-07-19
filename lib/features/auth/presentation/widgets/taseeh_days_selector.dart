import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/taseeh_days_option.dart';

/// اختيار أيام التسميع (بطاقتين قابلتين للاختيار)، خاص بصفحة
/// إنشاء الحساب.
class TaseehDaysSelector extends StatelessWidget {
  const TaseehDaysSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TaseehDaysOption selected;
  final ValueChanged<TaseehDaysOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('أيام التسميع', style: textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (int i = 0; i < TaseehDaysOption.values.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DayCard(
                  option: TaseehDaysOption.values[i],
                  isSelected: TaseehDaysOption.values[i] == selected,
                  onTap: () => onChanged(TaseehDaysOption.values[i]),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.option, required this.isSelected, required this.onTap});

  final TaseehDaysOption option;
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
