import 'package:academic_concourse_for_girls/features/student_home/domain/enities/student_dashboard_entity.dart';

import '../../../../core/bloc/request_status.dart';

class StudentDashboardState {
  const StudentDashboardState({
    this.status = RequestStatus.initial,
    this.data,
    this.errorMessage,
  });

  final RequestStatus status;
  final StudentDashboardEntity? data;
  final String? errorMessage;

  bool get isLoading => status == RequestStatus.loading;

  StudentDashboardState copyWith({
    RequestStatus? status,
    StudentDashboardEntity? data,
    String? errorMessage,
  }) {
    return StudentDashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}
