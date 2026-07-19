import 'package:flutter/foundation.dart';
//
// /// إعدادات التطبيق العامة (روابط API، مهلات الاتصال...).
// ///
// /// ملاحظة: isDebug تُشتق تلقائياً من وضع البناء (kDebugMode) بدل كتابتها
// /// يدوياً، حتى لا تنسي إرجاعها إلى false قبل إصدار نسخة الإنتاج.
// class AppConfig {
//   AppConfig._();
//
//   static const String laravelBaseUrl = 'http://127.0.0.1:8000/api/login';
//   static const int apiTimeoutInMillis = 30000;
//   static bool get isDebug => kDebugMode;
//
//   // مسارات الـ API (camelCase حسب قواعد تسمية Dart)
//   static const String loginPath = '/login';
//   static const String createProductPath = '/createProduct';
// }
import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String laravelBaseUrl = 'http://127.0.0.1:8000/api';
  static const int apiTimeoutInMillis = 30000;
  static bool get isDebug => kDebugMode;

  static const String loginPath = '/login';
  static const String registerPath = '/register';

  static const String teacherStudentsPath = '/teachers/students';
  static const String teacherStudentsCountPath = '/teachers/students/numbers'; // ✅ صححتها
  static const String teacherGroupAchievementPath = '/teacher/group-achievement';
  static const String teacherActiveStudentsPath = '/teacher/active-students';
  static const String teacherStudentByIdPath = '/teacher/student'; // ⬅️ جديد، رح نضيف الـ id بعدها
}