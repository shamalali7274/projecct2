/// مفتاح تطوير عام: لما يكون true، الـ Blocs (SignIn/SignUp) بتستخدم
/// AuthRepositoryMock بدل التواصل الفعلي مع الباك ايند.
/// لازم تصير false قبل إصدار نسخة الإنتاج.
class DevConfig {
  DevConfig._();
  static const bool useMockAuth = false;
}
