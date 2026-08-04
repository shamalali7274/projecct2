import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/colored_html_text.dart';
import '../../domain/entities/mawdi_entity.dart';

/// بطاقة موضع واحد من كتاب "التبيان المفصل لمتشابهات القرآن" —
/// تُعرض بعد كل صفحة مصحف فيها خطأ أحمر مرتبط بموضع مستخرج من الـ OCR
/// (RecitationSessionController@show → mawadi_by_page).
///
/// مكوّن قابل لإعادة الاستخدام بالكامل: مبني مرة واحدة ويُستدعى لأي
/// MawdiEntity، بلا أي منطق شبكة أو حالة داخله (Presentation-only).
class MawdiCard extends StatelessWidget {
  const MawdiCard({super.key, required this.mawdi});

  final MawdiEntity mawdi;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      backgroundColor: scheme.errorContainer.withOpacity(0.18),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, scheme),
          const SizedBox(height: AppSpacing.md),
          ColoredHtmlText(
            html: mawdi.html,
            baseStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.9),
          ),
          if (mawdi.matchedWords.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildMatchedWords(context, scheme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        Icon(Icons.menu_book_outlined, color: scheme.error, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'موضع متشابه رقم ${mawdi.mawdiNumber} — التبيان المفصل',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: scheme.error,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchedWords(BuildContext context, ColorScheme scheme) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      textDirection: TextDirection.rtl,
      children: [
        for (final word in mawdi.matchedWords)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.error.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              word,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.error),
            ),
          ),
      ],
    );
  }
}
