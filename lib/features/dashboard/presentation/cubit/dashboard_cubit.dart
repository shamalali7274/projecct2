// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/repositories/teacher_repository.dart';
// import '../../../../core/error/exceptions.dart';
// import 'dashboard_state.dart';
//
// /// يدير حالة لوحة الأنسة الرئيسية (قائمة طالباتها + إحصائياتها).
// /// نفس النمط المتّبع بـ AuthCubit: Repository يتعامل مع Dio، والـ
// /// Cubit بس يترجم النتيجة/الخطأ لحالة تعرضها الواجهة.
// class DashboardCubit extends Cubit<DashboardState> {
//   DashboardCubit({TeacherRepository? repository})
//       : _repository = repository ?? TeacherRepository(),
//         super(const DashboardInitial());
//
//   final TeacherRepository _repository;
//
//   Future<void> loadDashboard() async {
//     emit(const DashboardLoading());
//     try {
//       final data = await _repository.loadDashboard();
//       emit(DashboardLoaded(students: data.students, stats: data.stats));
//     } on AuthException catch (e) {
//       emit(DashboardError(e.message ?? 'انتهت صلاحية الجلسة، سجّلي الدخول من جديد'));
//     } on NetworkException catch (e) {
//       emit(DashboardError(e.message ?? 'تحققي من اتصال الإنترنت'));
//     } on ServerException catch (e) {
//       emit(DashboardError(e.message ?? 'حدث خطأ من الخادم، حاولي لاحقاً'));
//     } catch (_) {
//       emit(const DashboardError('حدث خطأ غير متوقع، حاولي مجدداً'));
//     }
//   }
// }

//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/repositories/teacher_repository.dart';
// import 'dashboard_state.dart';
//
// class DashboardCubit extends Cubit<DashboardState> {
//   DashboardCubit({TeacherRepository? repository})
//       : _repository = repository ?? TeacherRepository(),
//         super(const DashboardInitial());
//
//   final TeacherRepository _repository;
//
//   Future<void> loadDashboard() async {
//     emit(const DashboardLoading());
//     try {
//       final data = await _repository.loadDashboard();
//       emit(DashboardLoaded(students: data.students, stats: data.stats));
//     } catch (e) {
//       emit(DashboardError('تعذّر تحميل البيانات، حاولي مرة أخرى'));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/teacher_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({TeacherRepository? repository})
      : _repository = repository ?? TeacherRepository(),
        super(const DashboardInitial());

  final TeacherRepository _repository;

  Future<void> loadDashboard() async {
    if (isClosed) return;
    emit(const DashboardLoading());
    try {
      final data = await _repository.loadDashboard();
      if (isClosed) return;   // ✅ تأكدي إنه لسا مفتوح قبل ما تعملي emit
      emit(DashboardLoaded(students: data.students, stats: data.stats));
    } catch (e) {
      if (isClosed) return;   // ✅ نفس الشي هون
      emit(const DashboardError('تعذّر تحميل البيانات، حاولي مرة أخرى'));
    }
  }
}