import '../entities/auth_session_entity.dart';
import '../entities/sign_up_data_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionEntity> call(SignUpDataEntity data) {
    return _repository.signUp(data);
  }
}
