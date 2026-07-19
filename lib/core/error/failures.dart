/// أخطاء طبقة المنطق (Domain) — هاد اللي توصل عليه الواجهة أو الـ Bloc،
/// مو الـ Exception الخام. عند الربط مع الباك ايند، الـ Repository بيلقط
/// الـ Exception من core/error/exceptions.dart ويحوّله لـ Failure مناسب.
abstract class Failure {
  const Failure([this.message]);
  final String? message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'حدث خطأ غير متوقع']);
}
