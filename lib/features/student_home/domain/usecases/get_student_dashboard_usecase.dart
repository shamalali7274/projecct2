
import 'package:academic_concourse_for_girls/features/student_home/domain/enities/student_dashboard_entity.dart';
import 'package:academic_concourse_for_girls/features/student_home/domain/repo/student_repository.dart';

class GetStudentDashboardUseCase {
  const GetStudentDashboardUseCase(this._repository);
  final StudentRepository _repository;

  Future<StudentDashboardEntity> call() => _repository.getDashboard();
}
