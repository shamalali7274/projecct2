import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_credentials_entity.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/sign_up_data_entity.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/auth_repository.dart';

/// تنفيذ وهمي (DevConfig.useMockAuth = true فقط) — بيحفظ توكن ورول
/// وهميين بنفس آلية AuthRepositoryImpl الحقيقية، حتى AuthGate وباقي
/// التطبيق يتعاملوا معه بدون أي فرق.
class AuthRepositoryMock implements AuthRepository {
  AuthRepositoryMock({this.mockRole = UserRole.student});

  final UserRole mockRole;

  @override
  Future<AuthSessionEntity> signIn(AuthCredentialsEntity credentials) => _fakeSession();

  @override
  Future<AuthSessionEntity> signUp(SignUpDataEntity data) => _fakeSession();

  Future<AuthSessionEntity> _fakeSession() async {
    await Future.delayed(const Duration(milliseconds: 800));
    const token = 'mock-token-dev';

    await SecureStorage.saveToken(token);
    await SecureStorage.saveRole(mockRole.name);
    ApiClient.instance.setToken(token);

    return AuthSessionEntity(token: token, role: mockRole);
  }
}
