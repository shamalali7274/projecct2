/// استثناءات مصدرها طبقة البيانات (API / التخزين المحلي).
/// تُرمى داخل Data Sources / Repositories وتُلتقط لاحقاً وتُحوَّل
/// إلى Failure (في core/error/failures.dart) قبل ما توصل للواجهة.
class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;

  @override
  String toString() => message ?? 'ServerException';
}

class CacheException implements Exception {
  const CacheException([this.message]);
  final String? message;

  @override
  String toString() => message ?? 'CacheException';
}

class NetworkException implements Exception {
  const NetworkException([this.message]);
  final String? message;

  @override
  String toString() => message ?? 'NetworkException';
}

class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;

  @override
  String toString() => message ?? 'AuthException';
}
