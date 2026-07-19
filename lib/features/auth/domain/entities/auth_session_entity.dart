import 'user_role.dart';

/// نتيجة تسجيل الدخول/إنشاء الحساب الناجح — التوكن + نوع الحساب،
/// جايين مباشرة من استجابة الباك ايند (access_token + role).
class AuthSessionEntity {
  const AuthSessionEntity({required this.token, required this.role});

  final String token;
  final UserRole role;
}
