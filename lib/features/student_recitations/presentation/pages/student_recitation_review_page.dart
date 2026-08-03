import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/quran_accent_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../recitation/domain/entities/quran_page_entity.dart';
import '../../../recitation/presentation/widgets/highlightable_word.dart';

/// صفحة مراجعة تسميع الطالبة — نفس شكل صفحة المصحف عند الأنسة
/// تماماً (بطاقة مرفوعة + بسملة + نص ملوّن)، بما فيها أسلوب العرض:
/// كل صفحات التسميع تحت بعضها بسكرول متواصل واحد (SingleChildScrollView)
/// بدل التنقل بالسحب صفحة-صفحة، بس بوضع "عرض فقط" بالكامل هون:
/// الكلمات مبنية بـ readOnly:true فـ HighlightableWord، فما فيه
/// إمكانية إنو الطالبة تلمس/تبدّل أي تلوين حطّته الأنسة.
///
/// تحت آخر بطاقة، فيه "دليل الألوان" يشرح معنى كل لون — مبني آلياً
/// من enum WordHighlightColor نفسه (نفس المصدر يلي الأنسة تستخدمه
/// وقت التسميع) بدل ما نكرر النصوص يدوياً.
class StudentRecitationReviewPage extends StatelessWidget {
  const StudentRecitationReviewPage({
    super.key,
    required this.title,
    required this.pages,
  });

  /// عنوان التسميع (اسم السورة/الإنجاز) يظهر بالشريط العلوي.
  final String title;

  /// صفحات المصحف الخاصة بهاد التسميع بالضبط (بترتيبها).
  final List<QuranPageEntity> pages;

  @override
  Widget build(BuildContext context) {
    final hasMultiplePages = pages.length > 1;

    return Scaffold(
      appBar: AppTopBar(
        title: title,
        subtitle: pages.isEmpty
            ? ''
            : hasMultiplePages
                ? 'صفحة ${pages.first.pageNumber} - ${pages.last.pageNumber}'
                : 'صفحة ${pages.first.pageNumber}',
        avatarUrl: '',
        trailing: const ThemeToggleButton(),
      ),
      body: pages.isEmpty
          ? const Center(child: Text('لا يوجد نص مصحف مرتبط بهذا التسميع بعد'))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        for (int i = 0; i < pages.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i == pages.length - 1 ? 0 : AppSpacing.lg,
                            ),
                            child: _QuranPageCard(page: pages[i], showBasmala: i == 0),
                          ),
                      ],
                    ),
                  ),
                ),
                _buildColorLegend(context),
              ],
            ),
    );
  }

  /// دليل الألوان أسفل صفحات القرآن — يشرح للطالبة معنى كل لون
  /// ظللت فيه الأنسة كلماتها وقت التسميع. مبني من WordHighlightColor
  /// نفسه (استثناء "بدون تظليل") بدل تكرار الأسماء والألوان يدوياً.
  Widget _buildColorLegend(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final legendColors = WordHighlightColor.values.where((c) => c != WordHighlightColor.none);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(color: scheme.onSurface.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('دليل الألوان', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                for (final color in legendColors)
                  _LegendChip(color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuranPageCard extends StatelessWidget {
  const _QuranPageCard({required this.page, required this.showBasmala});

  final QuranPageEntity page;

  /// true بس للصفحة الأولى بالتسميع (مهما كانت أكتر من صفحة) —
  /// بنفس منطق pageIndex == 0 المستخدم بصفحة الآنسة (quran_recitation_page.dart)،
  /// حتى ما تتكرر البسملة بأول كل صفحة تانية.
  final bool showBasmala;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: Column(
        children: [
          if (showBasmala) ...[
            _buildBasmalaPill(context, scheme),
            const SizedBox(height: AppSpacing.xl),
          ],
          for (final line in page.lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Wrap(
                alignment: line.isCentered ? WrapAlignment.center : WrapAlignment.start,
                runSpacing: 16,
                spacing: 6,
                textDirection: TextDirection.rtl,
                children: [
                  for (final word in line.words)
                    HighlightableWord(
                      text: word.text,
                      highlight: word.highlight,
                      readOnly: true, // الطالبة تشوف بس، ما تقدر تعدّل تصحيح الأنسة
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasmalaPill(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        style: GoogleFonts.amiri(fontSize: 22, color: scheme.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color});

  final WordHighlightColor color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.background(context),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
          ),
        ),
        const SizedBox(width: 6),
        Text(color.label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}