/// نوع الحساب القادم من الباك ايند بعد تسجيل الدخول — هو اللي بيقرر
/// أي واجهة (الأنسة/المشرفة أو الطالبة) تُفتح بعد الدخول مباشرة.
enum UserRole { supervisor, student }

extension UserRoleX on UserRole {
  /// يحوّل قيمة role النصية القادمة من استجابة تسجيل الدخول (API)
  /// إلى UserRole. عدّلي الأسماء هون إذا الباك ايند بيرجع مسمّيات مختلفة.
  static UserRole fromApi(String value) {
    switch (value.toLowerCase().trim()) {
      case 'supervisor':
      case 'teacher':
      case 'musmiah':
        return UserRole.supervisor;
      case 'student':
        return UserRole.student;
      default:
        throw FormatException('دور مستخدم غير معروف من الباك ايند: $value');
    }
  }

  /// يحوّل القيمة المخزّنة محلياً (SecureStorage) رجوع إلى UserRole.
  static UserRole fromStored(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.student,
    );
  }
}
