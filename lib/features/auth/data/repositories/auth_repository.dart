import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/entities/user_role.dart';

/// المسؤول الوحيد عن التواصل مع API تسجيل الدخول وحفظ/استرجاع الجلسة
/// محلياً. الـ Cubit ما بيحكي مع Dio مباشرة أبداً — بيمر من هون فقط.
class AuthRepository {
  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  /// تسجيل دخول فعلي — مطابق لعقد AuthController@login الحقيقي:
  /// الطلب {number, password}, الاستجابة {message, access_token, role}.
  /// يرمي AuthException/NetworkException/ServerException عند الفشل،
  /// ويلتقطها AuthCubit.
  Future<AuthUserEntity> login({
    required String number,
    required String password,
  }) async {
    final response = await _apiClient.post(
      AppConfig.loginPath,
      data: {'number': number, 'password': password},
    );

    final data = response.data as Map<String, dynamic>;
    final token = data['access_token'] as String;
    final role = UserRoleX.fromApi(data['role'] as String);

    await SecureStorage.saveToken(token);
    await SecureStorage.saveRole(role.name);
    _apiClient.setToken(token);

    // ⚠️ استجابة الدخول الحالية ما فيها اسم المستخدمة (name) — تركتها
    // فاضية مؤقتاً. لما يصير عندك endpoint لجلب بيانات البروفايل
    // (مثلاً /me)، استدعيه هون واملأ الاسم منه.
    return AuthUserEntity(token: token, role: role, name: '');
  }

  /// يُستدعى عند فتح التطبيق للتحقق هل في جلسة محفوظة أصلاً (Auto
  /// Login) بدل إجبار المستخدمة تسجّل دخول من جديد كل مرة.
  /// يرجع null إذا ما في جلسة محفوظة.
  Future<AuthUserEntity?> restoreSession() async {
    final token = await SecureStorage.getToken();
    final storedRole = await SecureStorage.getRole();
    if (token == null || token.isEmpty || storedRole == null) return null;

    _apiClient.setToken(token);
    return AuthUserEntity(token: token, role: UserRoleX.fromStored(storedRole), name: '');
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    _apiClient.clearToken();
  }
}
