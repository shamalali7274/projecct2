/// بيانات تسجيل الدخول (رقم الهاتف + كلمة السر) — منفصلة عن شكل
/// الـ request الفعلي المُرسل للـ API.
class AuthCredentialsEntity {
  const AuthCredentialsEntity({required this.number, required this.password});

  final String number;
  final String password;
}
