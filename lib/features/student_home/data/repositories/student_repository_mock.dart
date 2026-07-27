import 'package:academic_concourse_for_girls/features/student_home/domain/enities/student_dashboard_entity.dart';
import 'package:academic_concourse_for_girls/features/student_home/domain/repo/student_repository.dart';

class StudentRepositoryMock implements StudentRepository {
  @override
  Future<StudentDashboardEntity> getDashboard() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const StudentDashboardEntity(
      id: 1,
      fullName: 'نورة العتيبي',
      goal: 20,
      path: 'أترجة',
      college: 'علوم الحاسب والمعلومات',
      achievement: 14,
      ranking: 12,
      collegeRanking: 4,
      pathRanking: 7,
    );
  }
}
