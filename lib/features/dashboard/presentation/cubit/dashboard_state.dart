import '../../domain/entities/student_entity.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

/// حالات لوحة الأنسة الرئيسية — بنفس فكرة AuthState.
abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded({required this.students, required this.stats});
  final List<StudentEntity> students;
  final DashboardStatsEntity stats;
}

class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;
}
