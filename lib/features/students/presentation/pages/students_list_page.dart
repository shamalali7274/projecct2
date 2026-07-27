import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_pastel_tiles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/student_card.dart';
import '../../../dashboard/data/repositories/teacher_repository.dart';
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
/// البيانات الافتراضية (بدون بحث) مصدرها نفس التابع بالضبط المستخدم
/// بقائمة "طالباتي" بلوحة المسمعة الرئيسية: DashboardCubit →
/// TeacherRepository.loadDashboard().
///
/// حقل البحث بالأعلى موصول بتابعين حقيقيين من TeachersController،
/// وكل هذا عبر نفس أيقونة البحث الوحيدة (بدون تكرار الأيقونة):
///   - لو الكتابة أرقام بس  → TeachersController@searchStudentById
///     (GET /teacher/student/{id})
///   - غير هيك (اسم)        → TeachersController@getStudentByName
///     (POST /teachers/students/name)
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

enum _SearchStatus { idle, loading, found, notFound }

class _StudentsListViewState extends State<_StudentsListView> {
  final int _navIndex = 1; // تبويب "الطالبات" هو الحالي بهاي الصفحة
  final TeacherRepository _teacherRepository = TeacherRepository();
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;
  _SearchStatus _searchStatus = _SearchStatus.idle;
  StudentEntity? _searchResult;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _searchStatus = _SearchStatus.idle;
        _searchResult = null;
      });
      return;
    }

    // تأخير بسيط (300ms) بدل ما نرسل نداء شبكة مع كل ضغطة حرف.
    _debounce = Timer(const Duration(milliseconds: 300), () => _runSearch(trimmed));
  }

  Future<void> _runSearch(String query) async {
    setState(() => _searchStatus = _SearchStatus.loading);

    // لو الكتابة أرقام بحتة → بحث برقم الطالبة (id)، وإلا بحث بالاسم.
    // نفس حقل البحث/الأيقونة، بس بتقرر شو تستدعي حسب شكل الكتابة.
    final isNumericId = RegExp(r'^\d+$').hasMatch(query);

    try {
      final result = isNumericId
          ? await _teacherRepository.getStudentById(int.parse(query))
          : await _teacherRepository.getStudentByName(query);

      if (!mounted) return;
      setState(() {
        _searchResult = result;
        _searchStatus = result == null ? _SearchStatus.notFound : _SearchStatus.found;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _searchStatus = _SearchStatus.notFound);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذّر البحث: $e')));
    }
  }

  void _openStudentDetail(StudentEntity student) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudentDetailPage(
          studentId: int.parse(student.id),
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

    final isSearching = _searchStatus != _SearchStatus.idle;
    final displayedStudents = isSearching
        ? (_searchResult == null ? const <StudentEntity>[] : [_searchResult!])
        : students;

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 120),
      children: [
        AppSearchField(
          controller: _searchController,
          hintText: 'ابحثي عن طالبة بالاسم أو برقمها',
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (_searchStatus == _SearchStatus.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_searchStatus == _SearchStatus.notFound)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: Text('ما في طالبة مطابقة لهاد البحث')),
          ),
        if (_searchStatus != _SearchStatus.loading)
          for (final entry in displayedStudents.asMap().entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: StudentCard(
                student: entry.value,
                tile: pastelTileForIndex(entry.key),
                onTap: () => _openStudentDetail(entry.value),
                onStartRecitation: () => startRecitationSession(
                  context,
                  studentId: int.parse(entry.value.id),
                  studentName: entry.value.name,
                ),
              ),
            ),
      ],
    );
  }
}
