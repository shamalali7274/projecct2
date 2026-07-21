
import 'package:academic_concourse_for_girls/features/student_home/domain/enities/student_dashboard_entity.dart';

abstract class StudentRepository {
  Future<StudentDashboardEntity> getDashboard();
}
