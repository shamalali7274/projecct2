import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_pastel_tiles.dart';

/// رأس صفحة الطالبة (الاسم + الجزء الحالي + نسبة الإنجاز) — مبني على
/// AppCard الموحّد بدل بطاقة مخصصة جديدة.
class StudentProfileHeader extends StatelessWidget {
  const StudentProfileHeader({
    super.key,
    required this.name,
    required this.currentJuz,
    required this.progressPercent,
  });

  final String name;
  final String currentJuz;
  final int progressPercent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      borderRadius: AppRadius.xl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: textTheme.titleLarge?.copyWith(color: scheme.primary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.menu_book, size: 18, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          style: textTheme.labelSmall,
                          children: [
                            const TextSpan(text: 'تدرس حالياً: '),
                            TextSpan(
                              text: currentJuz,
                              style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            decoration: BoxDecoration(
              color: PastelTile.sage.background(context),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              'إنجاز $progressPercent٪',
              style: textTheme.labelSmall?.copyWith(
                color: PastelTile.sage.foreground(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
