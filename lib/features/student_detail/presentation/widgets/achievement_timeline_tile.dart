import 'package:flutter/material.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_pastel_tiles.dart';

/// عنصر واحد بسجل الإنجازات: نقطة على الخط الزمني + بطاقة تفاصيل.
/// شكل النقطة ولون البطاقة يتغيّران تلقائياً حسب AchievementStatus،
/// بدل تكرار نفس التركيبة لكل حالة.
class AchievementTimelineTile extends StatelessWidget {
  const AchievementTimelineTile({
    super.key,
    required this.achievement,
    required this.isLast,
  });

  final AchievementEntity achievement;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMilestone = achievement.status == AchievementStatus.milestone;

    late final Color dotColor;
    late final Color dotFg;
    late final IconData dotIcon;
    switch (achievement.status) {
      case AchievementStatus.excellent:
        dotColor = PastelTile.sage.foreground(context);
        dotFg = Colors.white;
        dotIcon = Icons.check_circle;
        break;
      case AchievementStatus.goodReview:
        dotColor = PastelTile.lavender.foreground(context);
        dotFg = Colors.white;
        dotIcon = Icons.history;
        break;
      case AchievementStatus.milestone:
        dotColor = PastelTile.sand.foreground(context);
        dotFg = Colors.white;
        dotIcon = Icons.military_tech;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                child: Icon(dotIcon, size: 15, color: dotFg),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: scheme.outlineVariant.withOpacity(0.5)),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isMilestone
                      ? PastelTile.sand.background(context)
                      : scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: scheme.outlineVariant.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            achievement.title,
                            style: textTheme.titleMedium?.copyWith(
                              color: isMilestone ? PastelTile.sand.foreground(context) : scheme.onSurface,
                            ),
                          ),
                        ),
                        Text(achievement.dateLabel, style: textTheme.labelSmall),
                      ],
                    ),
                    if (achievement.note != null) ...[
                      const SizedBox(height: 6),
                      Text(achievement.note!, style: textTheme.bodySmall),
                    ],
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: scheme.secondaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(achievement.statusLabel, style: textTheme.labelSmall),
                        ),
                        if (achievement.pagesLabel.isNotEmpty)
                          Text(achievement.pagesLabel, style: textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
