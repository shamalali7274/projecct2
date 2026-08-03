import 'dart:math';
import 'package:academic_concourse_for_girls/features/student_home/domain/enities/student_dashboard_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/request_status.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/circular_progress_ring.dart';
import '../../../../core/widgets/stat_info_card.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../recitation/data/repositories/recitation_repository.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../student_recitations/presentation/pages/my_recitations_page.dart';
import '../cubit/student_dashboard_cubit.dart';
import '../cubit/student_dashboard_state.dart';

/// الواجهة الرئيسية للطالبة — تحويل مباشر لمخطط الـ HTML (Bento Grid)
/// لنفس نظام التصميم (AppColors/AppCard/CircularProgressRing...) اللي
/// التطبيق أصلاً مبني عليه.
///
/// نفس نمط DashboardPage (المعلّمة) تماماً: BlocProvider هون بالخارج،
/// و _StudentHomeView جوّا بتستهلك الحالة.
class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentDashboardCubit()..load(),
      child: const _StudentHomeView(),
    );
  }
}

class _StudentHomeView extends StatefulWidget {
  const _StudentHomeView();

  @override
  State<_StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<_StudentHomeView> {
  int _navIndex = 0;

  void _handleNavTap(int index) {
    if (index == 2) {
      // "تسميعاتي" — سجل تسميعات الطالبة نفسها (بديل تبويب "الفعاليات").
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MyRecitationsPage()),
      );
      return;
    }
    if (index == 4) {
      // "حسابي" — نفس صفحة الإعدادات المستخدمة بجانب المعلّمة، بس
      // مع بار سفلي خاص بالطالبة (5 تبويبات بدل 4). التبويبات
      // التانية (الكليات/المكتبة) لسا خارج نطاق هاي الجولة،
      // فبنكتفي بالرجوع للرئيسية لو ضغطت عليهم من هون.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SettingsPage(
            navIndex: 4,
            navItems: const [
              AppNavItem(icon: Icons.home_outlined, label: 'الرئيسية'),
              AppNavItem(icon: Icons.school_outlined, label: 'الكليات'),
              AppNavItem(icon: Icons.auto_stories_outlined, label: 'تسميعاتي'),
              AppNavItem(icon: Icons.local_library_outlined, label: 'المكتبة'),
              AppNavItem(icon: Icons.person_outline, label: 'حسابي'),
            ],
            onNavTap: (i) {
              if (i == 4) return;
              Navigator.of(context).pop();
            },
          ),
        ),
      );
      return;
    }
    // TODO: الكليات/المكتبة — صفحات لاحقة، خارج نطاق
    // هاي الجولة (ربط APIs الطالبة فقط). حالياً بس بتبدّل التبويب.
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'الملتقى الجامعي',
        subtitle: 'أهلاً بعودتكِ 🌿',
        avatarUrl: '',
        actions: const [AppTopBarAction(icon: Icons.notifications_none)],
        trailing: const ThemeToggleButton(),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _handleNavTap,
        items: const [
          AppNavItem(icon: Icons.home_outlined, label: 'الرئيسية'),
          AppNavItem(icon: Icons.school_outlined, label: 'الكليات'),
          AppNavItem(icon: Icons.auto_stories_outlined, label: 'تسميعاتي'),
          AppNavItem(icon: Icons.local_library_outlined, label: 'المكتبة'),
          AppNavItem(icon: Icons.person_outline, label: 'حسابي'),
        ],
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<StudentDashboardCubit, StudentDashboardState>(
          builder: (context, state) {
            if (state.status == RequestStatus.failure) {
              return _ErrorView(
                message: state.errorMessage ?? 'حدث خطأ',
                onRetry: () => context.read<StudentDashboardCubit>().load(),
              );
            }

            if (state.status != RequestStatus.success || state.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = state.data!;

            return RefreshIndicator(
              onRefresh: () => context.read<StudentDashboardCubit>().load(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.lg,
                  140,
                ),
                children: [
                  _HeroGreeting(name: data.fullName),
                  const SizedBox(height: AppSpacing.xxl),
                  // ═══ مسار الحفظ + بطاقة الهوية (نفس صف الـ HTML md:col-span-7/5) ═══
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 560;
                      final progressCard = _ProgressCard(data: data);
                      final idCard = _DigitalIdCard(data: data);
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 7, child: progressCard),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(flex: 5, child: idCard),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          progressCard,
                          const SizedBox(height: AppSpacing.lg),
                          idCard,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // ═══ سجل الإنجاز (Heat-map) — عرض فقط، بلا مصدر بيانات حقيقي بعد ═══
                  const _ActivityHeatmapCard(),
                  const SizedBox(height: AppSpacing.lg),
                  // ═══ الترتيب: عام / كلية / مسار ═══
                  StatInfoCard(
                    label: 'ترتيب الكلية',
                    value: 'المركز ${data.collegeRanking}',
                    icon: Icons.workspace_premium_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  StatInfoCard(
                    label: 'الترتيب العام',
                    value: 'المركز ${data.ranking}',
                    icon: Icons.military_tech_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  StatInfoCard(
                    label: 'ترتيب المسار (${data.path})',
                    value: 'المركز ${data.pathRanking}',
                    icon: Icons.route_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // ═══ تسجيل ورد اليوم — واجهة فقط، ما في endpoint لها بعد ═══
                  const _LogProgressCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroGreeting extends StatelessWidget {
  const _HeroGreeting({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final firstName = name.trim().isEmpty ? '' : name.trim().split(' ').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstName.isEmpty ? 'أهلاً بكِ' : 'أهلاً بكِ يا $firstName',
          style: textTheme.headlineMedium?.copyWith(color: scheme.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'يومٌ جديد ممتلئ بالبركة والجمال في رحاب القرآن.',
          style: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.data});
  final StudentDashboardEntity data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Text('مسار الحفظ الحالي', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          CircularProgressRing(
            percent: data.progressPercent,
            size: 160,
            label: '${data.achievement} / ${data.goal} جزء',
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'بارك الله فيكِ، استمري يا قمر ✨',
            style: textTheme.titleSmall?.copyWith(
              color: scheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _DigitalIdCard extends StatelessWidget {
  const _DigitalIdCard({required this.data});
  final StudentDashboardEntity data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      backgroundColor: scheme.primaryContainer,
      withShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.qr_code_2, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text(
                  'عضوية فضية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            data.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.college,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: Colors.white.withOpacity(0.15), height: 1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'المسار',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
          Text(
            '${data.path} — الهدف ${data.goal} جزء',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// سجل الإنجاز اليومي (Heat-map) — نفس تصميم الـ HTML، بس بلا مصدر
/// بيانات حقيقي حالياً (الـ 5 endpoints المُعطاة ما فيها نشاط يومي).
/// القيم هون عرض فقط (placeholder) — لما ينضاف endpoint مخصص لهاد
/// الغرض، بس بدّلي التوليد العشوائي تحت بقيم حقيقية من الـ API.
class _ActivityHeatmapCard extends StatelessWidget {
  const _ActivityHeatmapCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final random = Random(7); // seed ثابت حتى ما يتغيّر شكلها كل rebuild

    const days = [
      'السبت',
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('سجل الإنجاز اليومي', style: textTheme.titleMedium),
              Row(
                children: [
                  Icon(Icons.trending_up, size: 16, color: scheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'أداء ممتاز هذا الشهر',
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 35,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              final intensity = random.nextDouble();
              Color color = scheme.surfaceContainerHighest;
              if (intensity > 0.8) {
                color = scheme.primary;
              } else if (intensity > 0.5) {
                color = scheme.primary.withOpacity(0.6);
              } else if (intensity > 0.2) {
                color = scheme.primary.withOpacity(0.3);
              }
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days
                .map(
                  (d) => Text(
                    d,
                    style: textTheme.labelSmall?.copyWith(fontSize: 9),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// فورم تسجيل ورد اليوم — مربوط فعلياً بـ POST /recitation-sessions
/// (RecitationRepository.logDailyWird). الحقول هون "من صفحة" و"إلى
/// صفحة" مباشرة (مطابقة لـ from_page/to_page يلي الباك ايند بيطلبهم)
/// بدل "الجزء/الصفحات" القديمة، حتى ما يصير تحويل وسيط ممكن يغلط.
class _LogProgressCard extends StatefulWidget {
  const _LogProgressCard();

  @override
  State<_LogProgressCard> createState() => _LogProgressCardState();
}

class _LogProgressCardState extends State<_LogProgressCard> {
  final _repository = RecitationRepository();
  final _fromPageController = TextEditingController();
  final _toPageController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _fromPageController.dispose();
    _toPageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final fromPage = int.tryParse(_fromPageController.text.trim());
    final toPage = int.tryParse(_toPageController.text.trim());

    if (fromPage == null || toPage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقمي الصفحتين')),
      );
      return;
    }
    if (fromPage < 1 || toPage < 1 || toPage < fromPage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('صفحة النهاية يجب أن تكون أكبر من أو تساوي صفحة البداية'),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await _repository.logDailyWird(fromPage: fromPage, toPage: toPage);
      if (!mounted) return;
      _fromPageController.clear();
      _toPageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تسجيل الورد بنجاح، بارك الله فيكِ 🌿')),
      );
      // نحدّث لوحة الطالبة (الترتيب/الإنجاز) بعد تسجيل ورد جديد.
      await context.read<StudentDashboardCubit>().load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذّر تسجيل الورد: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Text('تسجيل ورد اليوم', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _fromPageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'من صفحة'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _toPageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'إلى صفحة'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('تحديث السجل'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
