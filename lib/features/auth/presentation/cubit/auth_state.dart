import '../../domain/entities/user_role.dart';

/// حالات تسجيل الدخول — بنفس فكرة ThemeCubit، بس بحالات أكتر لأنها
/// عملية شبكة (تحميل/نجاح/فشل) مو مجرد تبديل قيمة محلية.
abstract class AuthState {
  const AuthState();
}

/// الحالة الأولى قبل أي تحقق (لحظة فتح التطبيق).
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// أثناء تسجيل الدخول أو أثناء التحقق من جلسة محفوظة.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// تم تسجيل الدخول بنجاح — role هو اللي بيقرر أي واجهة تُفتح.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.role, this.name);
  final UserRole role;
  final String name;
}

/// ما في جلسة محفوظة، أو تم تسجيل الخروج.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// فشل تسجيل الدخول (بيانات خاطئة، لا يوجد اتصال...).
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}
