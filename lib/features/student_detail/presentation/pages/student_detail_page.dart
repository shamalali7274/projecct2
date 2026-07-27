import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/islamic_hero_illustration.dart';
import '../../../recitation/data/repositories/recitation_repository.dart';
import '../../../recitation/domain/entities/recitation_session_entity.dart';
import '../../../recitation/presentation/start_recitation.dart';
import '../../domain/entities/achievement_entity.dart';
import '../widgets/student_profile_header.dart';
import '../widgets/achievement_timeline_tile.dart';

/// صفحة "سجل الإنجازات" لطالبة واحدة — شو سمّعت، وايمتا، من أول مرة
/// سمّعت للأنسة لهلق. تُفتح عند الضغط على اسم الطالبة من أي قائمة
/// (اللوحة الرئيسية أو تبويب الطالبات)، بنفس السلوك تماماً.
///
/// البيانات هون حقيقية من الباك ايند:
/// GET /students/{studentId}/recitation-history (RecitationSessionController@history).
class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.avatarUrl,
    required this.currentJuz,
    required this.progressPercent,
  });

  final int studentId;
  final String studentName;
  final String avatarUrl;
  final String currentJuz;
  final int progressPercent;

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  final RecitationRepository _repository = RecitationRepository();

  bool _loading = true;
  String? _errorMessage;
  List<AchievementEntity> _achievements = const [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final sessions = await _repository.getHistory(widget.studentId);
      setState(() {
        _achievements = sessions.map(_toAchievement).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'تعذّر تحميل سجل الإنجازات: $e';
        _loading = false;
      });
    }
  }

  /// يحوّل جلسة تسميع حقيقية (RecitationSessionEntity) إلى بطاقة
  /// إنجاز بنفس شكل الخط الزمني الحالي. ملاحظة: الباك ايند حالياً ما
  /// عنده endpoint يرجّع نص الصفحات + الأخطاء لجلسة قديمة محددة (بعكس
  /// next-session اللي بترجعهم بس للجلسة القادمة)، فبطاقات السجل هون
  /// معروضة كملخص (نطاق الصفحات + التاريخ + التقييم) بدون فتح صفحة
  /// مصحف كاملة عند الضغط عليها حالياً.
  AchievementEntity _toAchievement(RecitationSessionEntity session) =>
      AchievementEntity.fromRecitationSession(session);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: widget.studentName,
        subtitle: 'سجل الإنجازات الكامل',
        avatarUrl: widget.avatarUrl,
        trailing: const ThemeToggleButton(),
      ),
      floatingActionButton: AppFab(
        label: 'بدء التسميع',
        icon: Icons.mic_none_rounded,
        onPressed: () => startRecitationSession(
          context,
          studentId: widget.studentId,
          studentName: widget.studentName,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        child: ListView(
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
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (!_loading && _errorMessage != null) _buildErrorState(context),
            if (!_loading && _errorMessage == null && _achievements.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(child: Text('لا يوجد سجل تسميع لهاي الطالبة بعد')),
              ),
            if (!_loading && _errorMessage == null)
              for (int i = 0; i < _achievements.length; i++)
                AchievementTimelineTile(
                  achievement: _achievements[i],
                  isLast: i == _achievements.length - 1,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Column(
      children: [
        Text(_errorMessage!, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.md),
        ElevatedButton(onPressed: _loadHistory, child: const Text('إعادة المحاولة')),
      ],
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
          child: Text('من الباك ايند مباشرة', style: Theme.of(context).textTheme.labelSmall),
        ),
      ],
    );
  }
}
