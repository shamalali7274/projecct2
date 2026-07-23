import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_pastel_tiles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/student_card.dart';
import '../../../dashboard/domain/entities/student_entity.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../../../student_detail/presentation/pages/student_detail_page.dart';
import '../../../recitation/presentation/start_recitation.dart';
import '../../../settings/presentation/pages/settings_page.dart';

/// صفحة "كل الطالبات" — نفس سلوك قائمة اللوحة الرئيسية بالضبط
/// (الضغط على الاسم يفتح سجل الإنجازات)، تُفتح من تبويب "الطالبات"
/// بالبار السفلي.
///
/// البيانات هون مصدرها نفس التابع بالضبط المستخدم بقائمة "طالباتي"
/// بلوحة المسمعة الرئيسية: DashboardCubit → TeacherRepository.loadDashboard()
/// (وبالتالي نفس نداء getStudents() تجاه الباك ايند) — بدل تكرار نداء
/// شبكة منفصل أو الاعتماد على بيانات وهمية بهاي الصفحة.
class StudentsListPage extends StatelessWidget {
  const StudentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..loadDashboard(),
      child: const _StudentsListView(),
    );
  }
}

class _StudentsListView extends StatefulWidget {
  const _StudentsListView();

  @override
  State<_StudentsListView> createState() => _StudentsListViewState();
}

class _StudentsListViewState extends State<_StudentsListView> {
  final int _navIndex = 1; // تبويب "الطالبات" هو الحالي بهاي الصفحة

  void _openStudentDetail(StudentEntity student) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudentDetailPage(
          studentName: student.name,
          avatarUrl: student.avatarUrl,
          currentJuz: 'الجزء ${student.completedParts.round()}',
          progressPercent: (student.progress * 100).round(),
        ),
      ),
    );
  }

  void _handleNavTap(int index) {
    if (index == _navIndex) return;
    if (index == 0) {
      Navigator.of(context).pop();
      return;
    }
    if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SettingsPage(
            navIndex: 3,
            navItems: const [
              AppNavItem(icon: Icons.dashboard, label: 'الرئيسية'),
              AppNavItem(icon: Icons.groups_outlined, label: 'الطالبات'),
              AppNavItem(icon: Icons.auto_stories_outlined, label: 'الإنجازات'),
              AppNavItem(icon: Icons.settings_outlined, label: 'الإعدادات'),
            ],
            onNavTap: (i) {
              if (i == 3) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
              if (i == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StudentsListPage()),
                );
              }
            },
          ),
        ),
      );
      return;
    }
    // باقي التبويبات (الإنجازات) TODO لاحقاً
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final students = state is DashboardLoaded ? state.students : const <StudentEntity>[];

        return Scaffold(
          appBar: AppTopBar(
            title: 'الطالبات',
            subtitle: state is DashboardLoaded
                ? '${students.length} طالبة مسجّلة'
                : 'جاري تحميل بيانات الطالبات...',
            avatarUrl: '',
            trailing: const ThemeToggleButton(),
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _navIndex,
            onTap: _handleNavTap,
            items: const [
              AppNavItem(icon: Icons.dashboard, label: 'الرئيسية'),
              AppNavItem(icon: Icons.groups_outlined, label: 'الطالبات'),
              AppNavItem(icon: Icons.auto_stories_outlined, label: 'الإنجازات'),
              AppNavItem(icon: Icons.settings_outlined, label: 'الإعدادات'),
            ],
          ),
          body: _buildBody(context, state, students),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    DashboardState state,
    List<StudentEntity> students,
  ) {
    if (state is DashboardLoading || state is DashboardInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DashboardError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => context.read<DashboardCubit>().loadDashboard(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 120),
      children: [
        AppSearchField(hintText: 'ابحثي عن طالبة بالاسم أو رقم العضوية', onFilterTap: () {}),
        const SizedBox(height: AppSpacing.xl),
        for (final entry in students.asMap().entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: StudentCard(
              student: entry.value,
              tile: pastelTileForIndex(entry.key),
              onTap: () => _openStudentDetail(entry.value),
              onStartRecitation: () => startRecitationSession(context, entry.value.name),
            ),
          ),
      ],
    );
  }
}
