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
///
/// [fromLogout] بتفرّق بين حالتين:
/// - false: أول فتح للتطبيق وما في جلسة محفوظة أصلاً → OnboardingPage
///   بكامل الشرائح (السلايدر من البداية).
/// - true: المستخدمة سجّلت خروج بنفسها من داخل التطبيق → لازم تروح
///   مباشرة لشريحة "لستِ وحدكِ في الرحلة" (تسجيل الدخول) بس، من دون
///   المرور على باقي شرائح الترحيب.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.fromLogout = false});
  final bool fromLogout;
}

/// فشل تسجيل الدخول (بيانات خاطئة، لا يوجد اتصال...).
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}
