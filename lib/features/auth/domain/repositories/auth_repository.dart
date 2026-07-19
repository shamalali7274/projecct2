import '../entities/auth_credentials_entity.dart';
import '../entities/auth_session_entity.dart';
import '../entities/sign_up_data_entity.dart';

/// عقد مجرّد (Interface) لعمليات المصادقة.
abstract class AuthRepository {
  Future<AuthSessionEntity> signIn(AuthCredentialsEntity credentials);
  Future<AuthSessionEntity> signUp(SignUpDataEntity data);
}
