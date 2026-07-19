import 'package:flutter/material.dart';
import 'app_card.dart';
import '../theme/app_pastel_tiles.dart';

/// بطاقة إحصائية موحّدة (تُستخدم لعرض عدد الطالبات، الإنجاز الجماعي...).
/// تُبنى مرة واحدة وتُغذّى بالقيم من الخارج بدل تكرار نفس البطاقة 3 مرات.
///
/// تدعم لون "بلاطة" ناعم اختياري (tile) لإعطاء كل بطاقة هويتها اللونية
/// الخاصة (متل الأسلوب اللي طلبتيه) — بدون tile بترجع للشكل الأبيض
/// العادي، فما في أي كود قديم بينكسر.
class StatInfoCard extends StatelessWidget {
  const StatInfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.unit,
    this.tile,
  });

  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final PastelTile? tile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final background = tile?.background(context) ?? scheme.surfaceContainerLowest;
    final accent = tile?.foreground(context) ?? scheme.primary;

    return AppCard(
      backgroundColor: background,
      withShadow: tile == null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: tile != null ? accent.withOpacity(0.85) : null,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: textTheme.headlineMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 4),
                    Text(unit!, style: textTheme.bodySmall?.copyWith(color: accent.withOpacity(0.8))),
                  ],
                ],
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accent, size: 26),
          ),
        ],
      ),
    );
  }
}
