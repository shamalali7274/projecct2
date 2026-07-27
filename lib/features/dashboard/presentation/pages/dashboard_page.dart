// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_dimensions.dart';
// import '../../../../core/theme/app_pastel_tiles.dart';
// import '../../../../core/widgets/app_top_bar.dart';
// import '../../../../core/widgets/app_search_field.dart';
// import '../../../../core/widgets/app_bottom_nav.dart';
// import '../../../../core/widgets/app_fab.dart';
// import '../../../../core/widgets/stat_info_card.dart';
// import '../../../../core/widgets/student_card.dart';
// import '../../../../core/widgets/theme_toggle_button.dart';
// import '../../../../core/widgets/islamic_hero_illustration.dart';
// import '../../../students/presentation/pages/students_list_page.dart';
// import '../../../student_detail/presentation/pages/student_detail_page.dart';
// import '../../../recitation/presentation/start_recitation.dart';
// import '../../data/mock/mock_students.dart';
// import '../../domain/entities/student_entity.dart';
// import '../../domain/entities/dashboard_stats_entity.dart';
//
// /// صفحة "لوحة المسمعة" الرئيسية.
// ///
// /// ملاحظة مهمة: البيانات أدناه (Mock) وهمية ومؤقتة فقط لبناء الواجهة.
// /// عند الربط مع الباك ايند سيتم استبدال هذا الـ State بـ DashboardBloc
// /// يجلب StudentEntity و DashboardStatsEntity عبر ApiClient (Dio)،
// /// والواجهة (build) لن تحتاج أي تعديل لأنها تتعامل مع نفس الكيانات.
// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});
//
//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage> {
//   int _navIndex = 0;
//
//   // TODO: استبدال هذه القيم لاحقاً عبر DashboardBloc + Dio
//   final DashboardStatsEntity _stats = const DashboardStatsEntity(
//     totalStudents: 27,
//     groupAchievementParts: 43,
//     activeStudents: 19,
//   );
//
//   // بيانات الطالبات مصدرها الآن MockStudents الموحّد بدل تكرارها هنا
//   // وبصفحة "كل الطالبات" بنفس الوقت.
//   List<StudentEntity> get _students => MockStudents.all;
//
//   void _openStudentDetail(StudentEntity student) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => StudentDetailPage(
//           studentName: student.name,
//           avatarUrl: student.avatarUrl,
//           currentJuz: 'الجزء ${student.completedParts.round()}',
//           progressPercent: (student.progress * 100).round(),
//         ),
//       ),
//     );
//   }
//
//   void _openStudentsList() {
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StudentsListPage()));
//   }
//
//   void _handleNavTap(int index) {
//     if (index == 1) {
//       _openStudentsList();
//       return;
//     }
//     // باقي التبويبات (الإنجازات/الإعدادات) TODO لاحقاً
//     setState(() => _navIndex = index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppTopBar(
//         title: 'لوحة المسمعة',
//         subtitle: 'مرحباً بكِ أختي المسمعة 🌿',
//         avatarUrl:
//             'https://lh3.googleusercontent.com/aida-public/AB6AXuAVwsiSJnsM7N_8HiK-bxK8voZh5nKkeV_YjRhismw75us28lXpKF-u5nrTpWr6COBvcQ-f8R-GGwNcuv-uHnCzqvvjvG33eQjSrvUfwB0DzmG8XyDUpYjhjuW7POdldzd0Pw526xlq47353gJOanYOL3AlVd40paIb0hj8noEmYAJGG0r04qKXQpQ83Oe4b2QSisVe7-LJUbz1iggDQMFta9mJ6rh2IViCxQ5NYd2Ar7XRnfFxdsBHpE8_vOnD2bCauw5e43tq77s',
//         actions: [
//           AppTopBarAction(icon: Icons.search, onTap: () {}),
//           AppTopBarAction(icon: Icons.notifications_none, onTap: () {}),
//         ],
//         trailing: const ThemeToggleButton(),
//       ),
//       floatingActionButton: AppFab(label: 'إضافة إنجاز يدوي', onPressed: () {}),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//       bottomNavigationBar: AppBottomNav(
//         currentIndex: _navIndex,
//         onTap: _handleNavTap,
//         items: const [
//           AppNavItem(icon: Icons.dashboard, label: 'الرئيسية'),
//           AppNavItem(icon: Icons.groups_outlined, label: 'الطالبات'),
//           AppNavItem(icon: Icons.auto_stories_outlined, label: 'الإنجازات'),
//           AppNavItem(icon: Icons.settings_outlined, label: 'الإعدادات'),
//         ],
//       ),
//       body: SafeArea(
//         top: false,
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 140),
//           children: [
//             _buildHeroSection(context),
//             const SizedBox(height: AppSpacing.xxl),
//             _buildStatsSection(context),
//             const SizedBox(height: AppSpacing.xxl),
//             AppSearchField(hintText: 'ابحثي عن طالبة بالاسم أو رقم العضوية', onFilterTap: () {}),
//             const SizedBox(height: AppSpacing.xxl),
//             _buildSectionHeader(context),
//             const SizedBox(height: AppSpacing.lg),
//             ..._students.asMap().entries.map(
//               (entry) => Padding(
//                 padding: const EdgeInsets.only(bottom: AppSpacing.lg),
//                 child: StudentCard(
//                   student: entry.value,
//                   tile: pastelTileForIndex(entry.key),
//                   onTap: () => _openStudentDetail(entry.value),
//                   onStartRecitation: () => startRecitationSession(context, entry.value.name),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeroSection(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Stack(
//       children: [
//         const IslamicHeroIllustration(),
//         Positioned(
//           right: AppSpacing.lg,
//           bottom: AppSpacing.lg,
//           left: AppSpacing.lg,
//           child: Text(
//             'بارك الله بجهودك في رعاية طالبات العلم 🌙',
//             style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatsSection(BuildContext context) {
//     // ملاحظة: على الشاشات العريضة (تابلت) يمكن تحويلها لصف أفقي لاحقاً
//     // عبر LayoutBuilder دون التأثير على StatInfoCard نفسه.
//     return Column(
//       children: [
//         StatInfoCard(
//           label: 'عدد طالباتي',
//           value: '${_stats.totalStudents}',
//           icon: Icons.groups_outlined,
//           tile: PastelTile.sage,
//         ),
//         const SizedBox(height: AppSpacing.md),
//         StatInfoCard(
//           label: 'الإنجاز الجماعي',
//           value: '${_stats.groupAchievementParts}',
//           unit: 'جزء',
//           icon: Icons.auto_stories_outlined,
//           tile: PastelTile.sand,
//         ),
//         const SizedBox(height: AppSpacing.md),
//         StatInfoCard(
//           label: 'الطالبات النشيطات',
//           value: '${_stats.activeStudents}',
//           icon: Icons.bolt_outlined,
//           tile: PastelTile.rose,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSectionHeader(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text('قائمة الطالبات', style: Theme.of(context).textTheme.headlineSmall),
//         TextButton.icon(
//           onPressed: _openStudentsList,
//           icon: Icon(Icons.arrow_back_ios, size: 14, color: scheme.primary),
//           label: Text(
//             'عرض الكل',
//             style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_pastel_tiles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/widgets/stat_info_card.dart';
import '../../../../core/widgets/student_card.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/islamic_hero_illustration.dart';
import '../../../students/presentation/pages/students_list_page.dart';
import '../../../student_detail/presentation/pages/student_detail_page.dart';
import '../../../recitation/presentation/start_recitation.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../domain/entities/student_entity.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..loadDashboard(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  int _navIndex = 0;

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

  void _openStudentsList() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StudentsListPage()));
  }

  void _openSettings() {
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
  }

  void _handleNavTap(int index) {
    if (index == 1) {
      _openStudentsList();
      return;
    }
    if (index == 3) {
      _openSettings();
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'لوحة المسمعة',
        subtitle: 'مرحباً بكِ أختي المسمعة 🌿',
        avatarUrl:
        '',
        actions: [
          AppTopBarAction(icon: Icons.search, onTap: _openStudentsList),
          AppTopBarAction(icon: Icons.notifications_none, onTap: () {}),
        ],
        trailing: const ThemeToggleButton(),
      ),
      floatingActionButton: AppFab(label: 'إضافة إنجاز يدوي', onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
      body: SafeArea(
        top: false,
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
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

            final loaded = state as DashboardLoaded;

            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 140),
              children: [
                _buildHeroSection(context),
                const SizedBox(height: AppSpacing.xxl),
                _buildStatsSection(context, loaded.stats),
                const SizedBox(height: AppSpacing.xxl),
                GestureDetector(
                  onTap: _openStudentsList,
                  child: AbsorbPointer(
                    child: AppSearchField(
                      hintText: 'ابحثي عن طالبة بالاسم أو رقم العضوية',
                      onFilterTap: _openStudentsList,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader(context),
                const SizedBox(height: AppSpacing.lg),
                ...loaded.students.asMap().entries.map(
                      (entry) => Padding(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        const IslamicHeroIllustration(),
        Positioned(
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
          left: AppSpacing.lg,
          child: Text(
            'بارك الله بجهودك في رعاية طالبات العلم 🌙',
            style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, dynamic stats) {
    return Column(
      children: [
        StatInfoCard(
          label: 'عدد طالباتي',
          value: '${stats.totalStudents}',
          icon: Icons.groups_outlined,
          tile: PastelTile.sage,
        ),
        const SizedBox(height: AppSpacing.md),
        StatInfoCard(
          label: 'الإنجاز الجماعي',
          value: '${stats.groupAchievementParts}',
          unit: 'جزء',
          icon: Icons.auto_stories_outlined,
          tile: PastelTile.sand,
        ),
        const SizedBox(height: AppSpacing.md),
        StatInfoCard(
          label: 'الطالبات النشيطات',
          value: '${stats.activeStudents}',
          icon: Icons.bolt_outlined,
          tile: PastelTile.rose,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('قائمة الطالبات', style: Theme.of(context).textTheme.headlineSmall),
        TextButton.icon(
          onPressed: _openStudentsList,
          icon: Icon(Icons.arrow_back_ios, size: 14, color: scheme.primary),
          label: Text(
            'عرض الكل',
            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}