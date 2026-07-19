import 'user_role.dart';

/// بيانات المستخدم بعد تسجيل الدخول بنجاح (أو استرجاع جلسة محفوظة).
class AuthUserEntity {
  const AuthUserEntity({
    required this.token,
    required this.role,
    required this.name,
  });

  final String token;
  final UserRole role;
  final String name;
}
