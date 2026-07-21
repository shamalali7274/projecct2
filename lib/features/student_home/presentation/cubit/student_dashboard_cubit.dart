import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/request_status.dart';
import '../../../../core/config/dev_config.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../data/repositories/student_repository_mock.dart';
import '../../domain/usecases/get_student_dashboard_usecase.dart';
import 'student_dashboard_state.dart';

class StudentDashboardCubit extends Cubit<StudentDashboardState> {
  StudentDashboardCubit({GetStudentDashboardUseCase? useCase})
    : _useCase =
          useCase ??
          GetStudentDashboardUseCase(
            DevConfig.useMockAuth
                ? StudentRepositoryMock()
                : StudentRepositoryImpl(),
          ),
      super(const StudentDashboardState());

  final GetStudentDashboardUseCase _useCase;

  Future<void> load() async {
    emit(state.copyWith(status: RequestStatus.loading));
    try {
      final data = await _useCase();
      if (isClosed) return; // ← أضيفي هاد
      emit(state.copyWith(status: RequestStatus.success, data: data));
    } catch (e) {
      if (isClosed) return; // ← وهاد
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
