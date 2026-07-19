import '../entities/auth_credentials_entity.dart';
import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

/// Use Case مسؤول فقط عن عملية "تسجيل الدخول".
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionEntity> call(AuthCredentialsEntity credentials) {
    return _repository.signIn(credentials);
  }
}
