import 'package:flutter/material.dart';
import '../../../../core/constants/quran_surah_names.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../recitation/domain/entities/quran_word_entity.dart';
import '../../../recitation/presentation/widgets/highlightable_word.dart';
import '../../domain/entities/smart_recitation_excerpt_entity.dart';

/// بطاقة عرض سؤال سبر واحد بشكل مقروء (readOnly، بدون تفاعل تظليل) —
/// نص المقطع كامل + شارة نوع الخطأ الأغلب فيه + رقم الصفحة/السورة.
/// نفس نمط _buildPageCard بصفحة التسميع العادية، بس ودجت مستقلة قابلة
/// لإعادة الاستخدام بدل تكرارها هون من جديد.
class SmartExcerptCard extends StatelessWidget {
  const SmartExcerptCard({super.key, required this.excerpt});

  final SmartRecitationExcerptEntity excerpt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final firstSurah = excerpt.lines.isNotEmpty ? excerpt.lines.first.surahNumber : 0;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                quranSurahLabel(firstSurah),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _buildCategoryBadge(context),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            excerpt.pagesLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.outline),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final line in excerpt.lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Wrap(
                alignment: line.isCentered ? WrapAlignment.center : WrapAlignment.start,
                runSpacing: 16,
                spacing: 6,
                textDirection: TextDirection.rtl,
                children: [
                  for (final QuranWordEntity word in line.words)
                    HighlightableWord(text: word.text, highlight: word.highlight, readOnly: true),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        excerpt.dominantCategoryLabel,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer),
      ),
    );
  }
}
