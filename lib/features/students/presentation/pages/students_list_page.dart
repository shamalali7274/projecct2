import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_pastel_tiles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/student_card.dart';
import '../../../dashboard/data/mock/mock_students.dart';
import '../../../dashboard/domain/entities/student_entity.dart';
import '../../../student_detail/presentation/pages/student_detail_page.dart';
import '../../../recitation/presentation/start_recitation.dart';

/// صفحة "كل الطالبات" — نفس سلوك قائمة اللوحة الرئيسية بالضبط
/// (الضغط على الاسم يفتح سجل الإنجازات)، تُفتح من تبويب "الطالبات"
/// بالبار السفلي.
class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
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

  @override
  Widget build(BuildContext context) {
    final students = MockStudents.all;

    return Scaffold(
      appBar: AppTopBar(
        title: 'الطالبات',
        subtitle: '${students.length} طالبة مسجّلة',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAVwsiSJnsM7N_8HiK-bxK8voZh5nKkeV_YjRhismw75us28lXpKF-u5nrTpWr6COBvcQ-f8R-GGwNcuv-uHnCzqvvjvG33eQjSrvUfwB0DzmG8XyDUpYjhjuW7POdldzd0Pw526xlq47353gJOanYOL3AlVd40paIb0hj8noEmYAJGG0r04qKXQpQ83Oe4b2QSisVe7-LJUbz1iggDQMFta9mJ6rh2IViCxQ5NYd2Ar7XRnfFxdsBHpE8_vOnD2bCauw5e43tq77s',
        trailing: const ThemeToggleButton(),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          if (i == 0) Navigator.of(context).pop();
          // باقي التبويبات (الإنجازات/الإعدادات) TODO لاحقاً
        },
        items: const [
          AppNavItem(icon: Icons.dashboard, label: 'الرئيسية'),
          AppNavItem(icon: Icons.groups_outlined, label: 'الطالبات'),
          AppNavItem(icon: Icons.auto_stories_outlined, label: 'الإنجازات'),
          AppNavItem(icon: Icons.settings_outlined, label: 'الإعدادات'),
        ],
      ),
      body: ListView(
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
      ),
    );
  }
}
