import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart';
import '../storage/secure_storage.dart';

/// يقرأ التوكن تلقائياً من SecureStorage قبل كل طلب — حتى بعد إعادة
/// فتح التطبيق (بدل الاعتماد فقط على setToken اليدوية بعد تسجيل الدخول).
class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey('Authorization')) {
      final token = await SecureStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }
}
// class _AuthInterceptor extends Interceptor {
//   @override
//   Future<void> onRequest(
//       RequestOptions options,
//       RequestInterceptorHandler handler,
//       ) async {
//     print('🔵 Interceptor started');  // ⬅️ أضيفي هاد
//     if (!options.headers.containsKey('Authorization')) {
//       final token = await SecureStorage.getToken();
//       print('🔵 Token retrieved: $token');  // ⬅️ وهاد
//       if (token != null && token.isNotEmpty) {
//         options.headers['Authorization'] = 'Bearer $token';
//       }
//     }
//     print('🔵 Interceptor finished');  // ⬅️ وهاد
//     return handler.next(options);
//   }
// }

/// عميل Dio مركزي واحد لكل التطبيق.
///
/// TODO: عند الربط الفعلي مع الباك ايند، استدعي ApiClient.instance.get/post/...
/// من داخل Repositories فقط (مو مباشرة من الواجهات).
class ApiClient {
  ApiClient._internal({required String baseUrl, required this.serverName})
    : log = Logger('ApiClient-$serverName') {
    _initLoggerOnce();

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConfig.apiTimeoutInMillis,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConfig.apiTimeoutInMillis,
        ),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ترتيب مهم: AuthInterceptor أولاً حتى يضيف التوكن قبل تسجيل الطلب
    dio.interceptors.add(_AuthInterceptor());

    // اللوغ يعمل فقط بوضع التطوير — ما بينشط أبداً بنسخة الإنتاج
    if (AppConfig.isDebug) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            log.info('[${options.method}] ${options.baseUrl}${options.path}');
            if (options.queryParameters.isNotEmpty) {
              log.fine('Query: ${options.queryParameters}');
            }
            if (options.data != null) {
              log.fine('Body: ${options.data}');
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
            log.info('Response[${response.statusCode}] => ${response.data}');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            log.severe('Error[${e.response?.statusCode}] => ${e.message}');
            return handler.next(e);
          },
        ),
      );
    }
  }

  static final ApiClient instance = ApiClient._internal(
    baseUrl: AppConfig.laravelBaseUrl,
    serverName: 'Laravel',
  );

  static bool _loggerInitialized = false;
  static void _initLoggerOnce() {
    if (_loggerInitialized) return;
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (AppConfig.isDebug) {
        // ignore: avoid_print
        print('${record.level.name}: ${record.loggerName} → ${record.message}');
      }
    });
    _loggerInitialized = true;
  }

  late final Dio dio;
  final Logger log;
  final String serverName;

  /// يُستدعى مباشرة بعد تسجيل الدخول (اختياري، لأن الـ AuthInterceptor
  /// أصلاً بيقرأ التوكن من SecureStorage تلقائياً بكل طلب).
  void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    dio.options.headers.remove('Authorization');
  }

  // ══════════════════════════════════════════════════════════════
  //  HTTP Methods
  // ══════════════════════════════════════════════════════════════

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH — لازم ميثود منفصل عن put()، لأنو Laravel بيفرّق بدقة بين
  /// PUT وPATCH بتعريف الراوت (Route::patch مثلاً)، وطلب PUT لراوت
  /// معرّف PATCH بيرجع 405 Method Not Allowed.
  Future<Response> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> uploadFile(
    String path, {
    required String filePath,
    String fieldName = 'file',
    Map<String, dynamic>? data,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });
      return await dio.post(path, data: formData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ══════════════════════════════════════════════════════════════
  //  Error Handler — يحوّل DioException إلى Exception من طبقتنا
  //  (core/error/exceptions.dart) بدل Exception عام غير منظّم
  // ══════════════════════════════════════════════════════════════
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException('انتهى وقت الاتصال بالخادم');
      case DioExceptionType.connectionError:
        return const NetworkException('لا يوجد اتصال بالإنترنت');
      case DioExceptionType.badCertificate:
        return const AuthException('مشكلة في التحقق من الشهادة');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const AuthException(
            'غير مصرح بالدخول، يرجى تسجيل الدخول مجدداً',
          );
        }
        return ServerException('خطأ في الاستجابة: $statusCode');
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ServerException(e.message ?? 'خطأ غير معروف');
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
