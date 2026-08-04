import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/request_status.dart';
import '../../../../core/navigation/page_transitions.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/circular_progress_ring.dart';
import '../../../../core/widgets/stat_info_card.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../recitation/data/repositories/recitation_repository.dart';
import '../../../recitation/domain/entities/recitation_session_entity.dart';
import '../../../student_detail/domain/entities/achievement_entity.dart';
import '../../../student_detail/presentation/widgets/achievement_timeline_tile.dart';
import '../../../student_home/domain/enities/student_dashboard_entity.dart';
import '../../../student_home/presentation/cubit/student_dashboard_cubit.dart';
import '../../../student_home/presentation/cubit/student_dashboard_state.dart';
import 'student_recitation_review_page.dart';

/// صفحة "تسميعاتي" — ملخص إنجاز حقيقي (الإنجاز/الهدف + الترتيب) من
/// نفس الـ 5 endpoints المستخدمة أصلاً بلوحة الطالبة الرئيسية، وتحته
/// سجل تسميعات حقيقي بالكامل من:
///   GET /students/{id}/recitation-history
///
/// الـ id هون صار متوفر لأول مرة (StudentDashboardEntity.id) بعد ما
/// عدّل الباك ايند GET /students/info وصار يرجّع 'id' مع باقي بيانات
/// الطالبة — قبل هيك كانت هاي الصفحة تعرض ملاحظة "قريباً" بدل بيانات
/// وهمية، وهلق صار ممكن نجيب السجل الحقيقي بالكامل.
class MyRecitationsPage extends StatelessWidget {
  const MyRecitationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentDashboardCubit()..load(),
      child: const _MyRecitationsView(),
    );
  }
}

class _MyRecitationsView extends StatelessWidget {
  const _MyRecitationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'تسميعاتي',
        subtitle: 'ملخص إنجازك وسجل تسميعاتك',
        avatarUrl: '',
        trailing: const ThemeToggleButton(),
      ),
      body: BlocBuilder<StudentDashboardCubit, StudentDashboardState>(
        builder: (context, state) {
          if (state.status == RequestStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? 'حدث خطأ'),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => context.read<StudentDashboardCubit>().load(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.status != RequestStatus.success || state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return _MyRecitationsBody(data: state.data!);
        },
      ),
    );
  }
}

class _MyRecitationsBody extends StatefulWidget {
  const _MyRecitationsBody({required this.data});
  final StudentDashboardEntity data;

  @override
  State<_MyRecitationsBody> createState() => _MyRecitationsBodyState();
}

enum _HistoryStatus { loading, loaded, error }

class _MyRecitationsBodyState extends State<_MyRecitationsBody> {
  final RecitationRepository _repository = RecitationRepository();

  _HistoryStatus _historyStatus = _HistoryStatus.loading;
  String? _historyError;
  List<AchievementEntity> _achievements = const [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  /// تُستدعى عند الضغط على أي تسميع بالسجل — بتجيب صفحات المصحف
  /// الخاصة فيه (مع تظليل الأخطاء يلي حطّتها الأنسة، إن وجدت) لحظياً
  /// من الباك ايند، وبعدين بتفتح صفحة المراجعة بوضع عرض فقط.
  Future<void> _openReview(AchievementEntity achievement) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final review = await _repository.getSessionReview(int.parse(achievement.id));
      if (!mounted) return;
      Navigator.of(context).pop(); // يسكر مؤشر التحميل

      AppNavigator.pushSharedAxis(
        context,
        StudentRecitationReviewPage(
          title: achievement.title,
          pages: review.pages,
          mawadiByPage: review.mawadiByPage,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذّر تحميل صفحات هذا التسميع: $e')),
      );
    }
  }

  Future<void> _loadHistory() async {
    setState(() => _historyStatus = _HistoryStatus.loading);
    try {
      final sessions = await _repository.getHistory(widget.data.id);
      if (!mounted) return;
      setState(() {
        _achievements = sessions.map(AchievementEntity.fromRecitationSession).toList();
        _historyStatus = _HistoryStatus.loaded;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _historyError = e.toString();
        _historyStatus = _HistoryStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 120),
        children: [
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                CircularProgressRing(percent: data.progressPercent, size: 96),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.achievement} من ${data.goal} جزء',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.progressPercent}% من هدفك الحالي',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('ترتيبك', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          StatInfoCard(
            label: 'الترتيب العام',
            value: 'المركز ${data.ranking}',
            icon: Icons.military_tech_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          StatInfoCard(
            label: 'ترتيب الكلية',
            value: 'المركز ${data.collegeRanking}',
            icon: Icons.workspace_premium_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          StatInfoCard(
            label: 'ترتيب المسار (${data.path})',
            value: 'المركز ${data.pathRanking}',
            icon: Icons.route_outlined,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('سجل التسميعات', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          _buildHistorySection(context),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    switch (_historyStatus) {
      case _HistoryStatus.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Center(child: CircularProgressIndicator()),
        );
      case _HistoryStatus.error:
        return Column(
          children: [
            Text('تعذّر تحميل سجل التسميعات: $_historyError', textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(onPressed: _loadHistory, child: const Text('إعادة المحاولة')),
          ],
        );
      case _HistoryStatus.loaded:
        if (_achievements.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: Text('لسا ما في تسميعات مسجّلة إلك')),
          );
        }
        return Column(
          children: [
            for (int i = 0; i < _achievements.length; i++)
              AchievementTimelineTile(
                achievement: _achievements[i],
                isLast: i == _achievements.length - 1,
                onTap: () => _openReview(_achievements[i]),
              ),
          ],
        );
    }
  }
}