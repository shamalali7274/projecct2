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
/// (بطاقة مرفوعة + بسملة + نص ملوّن) بس بوضع "عرض فقط" بالكامل:
/// الكلمات هون مبنية بـ readOnly:true فـ HighlightableWord، فما
/// فيه إمكانية إنو الطالبة تلمس/تبدّل أي تلوين حطّته الأنسة.
///
/// إذا كان التسميع (الإنجاز) بمتضمن أكتر من صفحة مصحف، بتقدر
/// الطالبة تتنقل بينهم بالسحب (PageView) + مؤشر صفحات بالأسفل.
/// وتحت البطاقة مباشرة، فيه "دليل الألوان" يشرح معنى كل لون —
/// مبني آلياً من enum WordHighlightColor نفسه (نفس المصدر يلي
/// الأنسة تستخدمه وقت التسميع) بدل ما نكرر النصوص يدوياً.
class StudentRecitationReviewPage extends StatefulWidget {
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
  State<StudentRecitationReviewPage> createState() => _StudentRecitationReviewPageState();
}

class _StudentRecitationReviewPageState extends State<StudentRecitationReviewPage> {
  late final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiplePages = widget.pages.length > 1;

    return Scaffold(
      appBar: AppTopBar(
        title: widget.title,
        subtitle: hasMultiplePages
            ? 'صفحة ${widget.pages[_currentPage].pageNumber} '
                '(${_currentPage + 1} من ${widget.pages.length})'
            : 'صفحة ${widget.pages.first.pageNumber}',
        avatarUrl: '',
        trailing: const ThemeToggleButton(),
      ),
      body: widget.pages.isEmpty
          ? const Center(child: Text('لا يوجد نص مصحف مرتبط بهذا التسميع بعد'))
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    reverse: true, // تصفّح من اليمين لليسار بانسجام مع اتجاه المصحف
                    itemCount: widget.pages.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) => SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: _QuranPageCard(page: widget.pages[index]),
                    ),
                  ),
                ),
                if (hasMultiplePages) _buildPageIndicator(context),
                _buildColorLegend(context),
              ],
            ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.pages.length, (i) {
          final isActive = i == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? scheme.primary : scheme.outlineVariant,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          );
        }),
      ),
    );
  }

  /// دليل الألوان أسفل صفحة القرآن — يشرح للطالبة معنى كل لون
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
  const _QuranPageCard({required this.page});

  final QuranPageEntity page;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: Column(
        children: [
          _buildBasmalaPill(context, scheme),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 16,
            spacing: 6,
            textDirection: TextDirection.rtl,
            children: [
              for (final word in page.words)
                HighlightableWord(
                  text: word.text,
                  highlight: word.highlight,
                  readOnly: true, // الطالبة تشوف بس، ما تقدر تعدّل تصحيح الأنسة
                ),
            ],
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
