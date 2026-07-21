import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();
  static String get laravelBaseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    return 'http://192.168.1.102:8000/api';
  }

  // static const String laravelBaseUrl = 'http://127.0.0.1:8000/api';
  static const int apiTimeoutInMillis = 30000;
  static bool get isDebug => kDebugMode;

  static const String loginPath = '/login';
  static const String registerPath = '/register';

  static const String teacherStudentsPath = '/teachers/students';
  static const String teacherStudentsCountPath =
      '/teachers/students/numbers'; // ✅ صححتها
  static const String teacherGroupAchievementPath =
      '/teacher/group-achievement';
  static const String teacherActiveStudentsPath = '/teacher/active-students';
  static const String teacherStudentByIdPath =
      '/teacher/student'; // ⬅️ جديد، رح نضيف الـ id بعدها
}
