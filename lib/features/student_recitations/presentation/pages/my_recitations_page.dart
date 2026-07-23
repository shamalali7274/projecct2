import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/quran_accent_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/islamic_hero_illustration.dart';
import '../../../recitation/domain/entities/quran_page_entity.dart';
import '../../../recitation/domain/entities/quran_word_entity.dart';
import '../../../student_detail/domain/entities/achievement_entity.dart';
import '../../../student_detail/presentation/widgets/achievement_timeline_tile.dart';
import 'student_recitation_review_page.dart';

/// صفحة "تسميعاتي" — نفس تصميم صفحة سجل الإنجازات المستخدمة عند
/// الأنسة تماماً (AchievementTimelineTile نفسه)، بس من منظور الطالبة
/// لسجل تسميعها الخاص فيها هي بس. تُفتح من تبويب "تسميعاتي" بالبار
/// السفلي (بدّلنا فيه مكان "الفعاليات").
///
/// الضغط على أي إنجاز فيه صفحات مصحف مرتبطة (quranPages) بيفتح
/// StudentRecitationReviewPage لعرض بالضبط شو سمّعت وكيف صحّحت
/// الأنسة أخطاءها، بشكل قراءة فقط.
class MyRecitationsPage extends StatefulWidget {
  const MyRecitationsPage({super.key});

  @override
  State<MyRecitationsPage> createState() => _MyRecitationsPageState();
}

class _MyRecitationsPageState extends State<MyRecitationsPage> {
  // TODO: استبدال هذه القائمة لاحقاً عبر StudentRecitationsCubit + Dio
  // (GET /me/achievements) — بنفس شكل AchievementEntity المستخدم
  // أصلاً بجانب الأنسة، فقط الفرق إنو المصدر هون "أنا" بدل طالبة
  // محددة تختارها الأنسة من قائمة.
  late final List<AchievementEntity> _achievements = _buildMockAchievements();

  List<AchievementEntity> _buildMockAchievements() {
    return [
      AchievementEntity(
        id: '1',
        title: 'سورة الكهف',
        dateLabel: '٢٤ أكتوبر ٢٠٢٣',
        pagesLabel: 'الصفحات ٢٩٣ - ٢٩٥',
        statusLabel: 'ممتاز',
        status: AchievementStatus.excellent,
        quranPages: _mockPages(surahIntro: true, count: 3, fromPage: 293),
      ),
      AchievementEntity(
        id: '2',
        title: 'سورة الإسراء',
        dateLabel: '٢٠ أكتوبر ٢٠٢٣',
        pagesLabel: 'الصفحات ٢٨٢ - ٢٨٣',
        statusLabel: 'ممتاز',
        status: AchievementStatus.excellent,
        quranPages: _mockPages(surahIntro: false, count: 2, fromPage: 282),
      ),
      AchievementEntity(
        id: '3',
        title: 'سورة النحل',
        dateLabel: '١٥ أكتوبر ٢٠٢٣',
        pagesLabel: 'الصفحة ٢٦٧',
        statusLabel: 'مراجعة جيدة',
        status: AchievementStatus.goodReview,
        quranPages: _mockPages(surahIntro: false, count: 1, fromPage: 267),
      ),
      const AchievementEntity(
        id: '4',
        title: 'إنجاز الجزء ١٤',
        dateLabel: '١٠ أكتوبر ٢٠٢٣',
        pagesLabel: '',
        statusLabel: 'تم الإتقان',
        status: AchievementStatus.milestone,
        note: 'تم إتمام حفظ الجزء الرابع عشر كاملاً مع تجويد متقن.',
        // بدون quranPages عمداً: هاد إنجاز عام (اجتياز جزء) مو تسميع
        // صفحة محددة، فبتضل بطاقته غير قابلة للضغط.
      ),
    ];
  }

  /// توليد صفحات تجريبية للعرض فقط (بنفس نص الفاتحة المستخدم بصفحة
  /// المصحف عند الأنسة) — لحد ما يرتبط الـ endpoint الفعلي لجلب نص
  /// كل صفحة تسميع مع تظليلها الحقيقي.
  List<QuranPageEntity> _mockPages({
    required bool surahIntro,
    required int count,
    required int fromPage,
  }) {
    const text = 'الْحَمْدُ لِلَّهِ الَّذِي أَنْزَلَ عَلَى عَبْدِهِ الْكِتَابَ '
        'وَلَمْ يَجْعَلْ لَهُ عِوَجًا قَيِّمًا لِيُنْذِرَ بَأْسًا '
        'شَدِيدًا مِنْ لَدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِينَ الَّذِينَ '
        'يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا حَسَنًا';
    final words = text.split(' ');

    return List.generate(count, (pageIndex) {
      return QuranPageEntity(
        pageNumber: fromPage + pageIndex,
        words: List.generate(words.length, (i) {
          // تلوين تجريبي متكرر فقط لإظهار شكل الدليل — التلوين
          // الحقيقي رح ييجي من ملاحظات الأنسة الفعلية بالباك ايند.
          final highlight = (i == 2 + pageIndex)
              ? WordHighlightColor.red
              : (i == 6)
                  ? WordHighlightColor.blue
                  : (i == 10)
                      ? WordHighlightColor.green
                      : WordHighlightColor.none;
          return QuranWordEntity(id: '$pageIndex-$i', text: words[i], highlight: highlight);
        }),
      );
    });
  }

  void _openReview(AchievementEntity achievement) {
    final pages = achievement.quranPages;
    if (pages == null || pages.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudentRecitationReviewPage(title: achievement.title, pages: pages),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'تسميعاتي',
        subtitle: 'سجل تسميعاتك الكامل',
        avatarUrl: '',
        trailing: const ThemeToggleButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 120),
        children: [
          const IslamicHeroIllustration(height: 110),
          const SizedBox(height: AppSpacing.xxl),
          Text('سجل التسميعات', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          for (int i = 0; i < _achievements.length; i++)
            AchievementTimelineTile(
              achievement: _achievements[i],
              isLast: i == _achievements.length - 1,
              onTap: _achievements[i].quranPages == null || _achievements[i].quranPages!.isEmpty
                  ? null
                  : () => _openReview(_achievements[i]),
            ),
        ],
      ),
    );
  }
}
