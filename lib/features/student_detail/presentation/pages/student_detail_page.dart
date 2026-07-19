import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/islamic_hero_illustration.dart';
import '../../../recitation/presentation/start_recitation.dart';
import '../../domain/entities/achievement_entity.dart';
import '../widgets/student_profile_header.dart';
import '../widgets/achievement_timeline_tile.dart';

/// صفحة "سجل الإنجازات" لطالبة واحدة — شو سمّعت، وايمتا، من أول مرة
/// سمّعت للأنسة لهلق. تُفتح عند الضغط على اسم الطالبة من أي قائمة
/// (اللوحة الرئيسية أو تبويب الطالبات)، بنفس السلوك تماماً.
class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({
    super.key,
    required this.studentName,
    required this.avatarUrl,
    required this.currentJuz,
    required this.progressPercent,
  });

  final String studentName;
  final String avatarUrl;
  final String currentJuz;
  final int progressPercent;

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  // TODO: استبدال هذه القائمة لاحقاً عبر StudentDetailBloc + Dio
  // (GET /students/{id}/achievements)
  final List<AchievementEntity> _achievements = const [
    AchievementEntity(
      id: '1',
      title: 'سورة الكهف',
      dateLabel: '٢٤ أكتوبر ٢٠٢٣',
      pagesLabel: 'الصفحات ٢٩٣ - ٣٠٤',
      statusLabel: 'ممتاز',
      status: AchievementStatus.excellent,
    ),
    AchievementEntity(
      id: '2',
      title: 'سورة الإسراء',
      dateLabel: '٢٠ أكتوبر ٢٠٢٣',
      pagesLabel: 'الصفحات ٢٨٢ - ٢٩٢',
      statusLabel: 'ممتاز',
      status: AchievementStatus.excellent,
    ),
    AchievementEntity(
      id: '3',
      title: 'سورة النحل',
      dateLabel: '١٥ أكتوبر ٢٠٢٣',
      pagesLabel: 'الصفحات ٢٦٧ - ٢٨١',
      statusLabel: 'مراجعة جيدة',
      status: AchievementStatus.goodReview,
    ),
    AchievementEntity(
      id: '4',
      title: 'إنجاز الجزء ١٤',
      dateLabel: '١٠ أكتوبر ٢٠٢٣',
      pagesLabel: '',
      statusLabel: 'تم الإتقان',
      status: AchievementStatus.milestone,
      note: 'تم إتمام حفظ الجزء الرابع عشر كاملاً مع تجويد متقن.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: widget.studentName,
        subtitle: 'سجل الإنجازات الكامل',
        avatarUrl: widget.avatarUrl,
        actions: [AppTopBarAction(icon: Icons.settings_outlined, onTap: () {})],
        trailing: const ThemeToggleButton(),
      ),
      floatingActionButton: AppFab(
        label: 'بدء التسميع',
        icon: Icons.mic_none_rounded,
        onPressed: () => startRecitationSession(context, widget.studentName),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 120),
        children: [
          const IslamicHeroIllustration(height: 110),
          const SizedBox(height: AppSpacing.lg),
          StudentProfileHeader(
            name: widget.studentName,
            currentJuz: widget.currentJuz,
            progressPercent: widget.progressPercent,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader(context),
          const SizedBox(height: AppSpacing.md),
          for (int i = 0; i < _achievements.length; i++)
            AchievementTimelineTile(
              achievement: _achievements[i],
              isLast: i == _achievements.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('سجل الإنجازات', style: Theme.of(context).textTheme.headlineSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text('آخر ٣٠ يوم', style: Theme.of(context).textTheme.labelSmall),
        ),
      ],
    );
  }
}
