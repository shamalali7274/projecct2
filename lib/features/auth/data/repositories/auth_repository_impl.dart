import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_credentials_entity.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/sign_up_data_entity.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}

/// التنفيذ الفعلي لعقد AuthRepository عبر Dio.
///
/// شكل استجابة الباك ايند لكل من /auth/login و /auth/register:
/// { "message": "...", "access_token": "...", "role": "teacher" }
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  @override
  Future<AuthSessionEntity> signIn(AuthCredentialsEntity credentials) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'number': credentials.number, 'password': credentials.password},
      );
      return _handleSignInResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AuthException(_mapDioError(e));
    }
  }

  @override
  Future<AuthSessionEntity> signUp(SignUpDataEntity data) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'first_name': data.firstName,
          'father_name': data.fatherName,
          'last_name': data.lastName,
          'mother_name': data.motherName,
          'college': data.college,
          'home_address': data.address,
          'number': data.number,
          'goal': data.targetParts,
          'start_page': data.pageFrom,
          'end_page': data.pageTo,
          'days_of_memorization': data.taseehDays.apiValue,
          'path': data.masar.apiValue,
          'password': data.password,
        },
      );
      
      return _handleSignUpResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AuthException(_mapDioError(e));
    }
  }

  /// يقرأ access_token و role من استجابة الباك ايند، ويحفظهم محلياً
  /// فوراً (SecureStorage) + يفعّل التوكن بـ ApiClient — بدل ما تتوزع
  /// مسؤولية الحفظ بين الـ Bloc والـ Repository.
   Future<AuthSessionEntity> _handleSignInResponse(Map<String, dynamic> json) async {
      final token = json['access_token'] as String?;
      final roleRaw = json['role'] as String?;
      if (token == null || token.isEmpty || roleRaw == null) {
        throw AuthException('استجابة غير متوقعة من الخادم');
      }
      final role = UserRoleX.fromApi(roleRaw);
      await SecureStorage.saveToken(token);
      await SecureStorage.saveRole(role.name);
      ApiClient.instance.setToken(token);
      return AuthSessionEntity(token: token, role: role);
    }

    /// رد /register ما فيه role أبداً (الباك إند ما بيرجعها بعد التسجيل)،
    /// وبما إنو أي حساب جديد بينسجل تلقائياً كـ student بالباك إند،
    /// منحطها هون صراحة بدل ما نستناها من رد ما رح توصل أبداً.
    Future<AuthSessionEntity> _handleSignUpResponse(Map<String, dynamic> json) async {
      final token = json['access_token'] as String?;
      if (token == null || token.isEmpty) {
        throw AuthException('استجابة غير متوقعة من الخادم');
      }
      const role = UserRole.student;
      await SecureStorage.saveToken(token);
      await SecureStorage.saveRole(role.name);
      ApiClient.instance.setToken(token);
      return AuthSessionEntity(token: token, role: role);
    }

  String _mapDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return 'الاسم أو كلمة السر غير صحيحة';
    }
    if (e.response?.statusCode == 409) {
      return 'رقم الهاتف مسجّل مسبقاً';
    }
    if (e.response?.statusCode == 422) {
      final data = e.response?.data;
      if (data is Map && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstFieldErrors = errors.values.first;
        if (firstFieldErrors is List && firstFieldErrors.isNotEmpty) {
          return firstFieldErrors.first.toString();
        }
      }
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return 'تحققي من صحة البيانات المدخلة';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال، تحققي من الإنترنت';
    }
    return 'حدث خطأ، حاولي مرة أخرى';
  }
}
