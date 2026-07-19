abstract class SignInEvent {
  const SignInEvent();
}

/// يُطلق عند الضغط على زر "تسجيل الدخول".
class SignInSubmitted extends SignInEvent {
  const SignInSubmitted({required this.number, required this.password});

  final String number;
  final String password;
}
