// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/storage/secure_storage.dart';
// import '../../domain/entities/user_role.dart';
// import 'auth_state.dart';
//
// /// يدير حالة الجلسة العامة للتطبيق فقط: فحص وجود جلسة محفوظة عند
// /// فتح التطبيق، وتسجيل الخروج. عملية تسجيل الدخول/إنشاء الحساب
// /// الفعلية صارت مسؤولية SignInBloc/SignUpBloc + AuthRepositoryImpl،
// /// اللي بيحفظوا التوكن والـ role بـ SecureStorage فور النجاح.
// /// AuthGate هو الوحيد اللي بيسمع لهاد الـ Cubit ويقرر أي واجهة تُفتح.
// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit() : super(const AuthInitial());
//
//   Future<void> checkAuthStatus() async {
//     emit(const AuthLoading());
//     final token = await SecureStorage.getToken();
//     final storedRole = await SecureStorage.getRole();
//
//     if (token == null || token.isEmpty || storedRole == null) {
//       emit(const AuthUnauthenticated());
//       return;
//     }
//
//     ApiClient.instance.setToken(token);
//     emit(AuthAuthenticated(UserRoleX.fromStored(storedRole), ''));
//   }
//
//   Future<void> logout() async {
//     await SecureStorage.clearAll();
//     ApiClient.instance.clearToken();
//     emit(const AuthUnauthenticated());
//   }
//
//   /// يُستدعى مباشرة من SignInPage/SignUpPage بعد نجاح تسجيل الدخول/
//   /// إنشاء الحساب، حتى تتحدث حالة الجلسة العامة فوراً (بدل انتظار
//   /// إعادة فتح التطبيق) ويقدر AuthGate يوجّه فوراً حسب الـ role.
//   void markAuthenticated(UserRole role) {
//     emit(AuthAuthenticated(role, ''));
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_role.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final token = await SecureStorage.getToken();
    final storedRole = await SecureStorage.getRole();

    if (token == null || token.isEmpty || storedRole == null) {
      emit(const AuthUnauthenticated());
      return;
    }

    ApiClient.instance.setToken(token);
    emit(AuthAuthenticated(UserRoleX.fromStored(storedRole), ''));
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    ApiClient.instance.clearToken();
    emit(const AuthUnauthenticated());
  }

  void markAuthenticated(UserRole role) {
    emit(AuthAuthenticated(role, ''));
  }

  /// تسجيل دخول فعلي بالـ API — عدّلي جسم الدالة لما يجهز عندك
  /// AuthRepository الحقيقي، هلق هاد نداء مباشر مؤقت.
  Future<void> login({required String number, required String password}) async {
    emit(const AuthLoading());
    try {
      final response = await ApiClient.instance.post(
        '/login',
        data: {'number': number, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['access_token'] as String;
      final roleStr = data['role'] as String;

      await SecureStorage.saveToken(token);
      await SecureStorage.saveRole(roleStr);
      ApiClient.instance.setToken(token);

      emit(AuthAuthenticated(UserRoleX.fromStored(roleStr), token));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// دخول تجريبي بدون باك ايند — لوضع Debug فقط
  void loginAsDev(UserRole role) {
    emit(AuthAuthenticated(role, 'dev-token'));
  }
}
