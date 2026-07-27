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
  // AuthController@logout -> Route::get('logout', ...) بالباك ايند صار GET
  // مو POST (كان مضبوط غلط سابقاً)، فحدّثنا الميثود بمكان الاستدعاء بـ
  // AuthCubit.logout() تبعاً لهيك.
  static const String logoutPath = '/logout';

  // ══════════════════ TeachersController ══════════════════
  static const String teacherStudentsPath = '/teachers/students';
  static const String teacherStudentsCountPath = '/teachers/students/numbers';
  static const String teacherGroupAchievementPath = '/teacher/group-achievement';
  static const String teacherActiveStudentsPath = '/teacher/active-students';
  static const String teacherStudentByIdPath = '/teacher/student'; // + '/$id'
  static const String teacherStudentByNamePath = '/teachers/students/name';

  // ══════════════════ StudentsController (بيانات الطالبة لحالها) ══════════════════
  static const String studentInfoPath = '/students/info';
  static const String studentRankingPath = '/students/ranking';
  static const String studentCollegeRankingPath = '/students/college-ranking';
  static const String studentPathRankingPath = '/students/path-ranking';
  static const String studentAchievementRelationToGoalPath =
      '/students/achievement_relation_to_goal';

  // ══════════════════ RecitationSessionController ══════════════════
  static const String recitationSessionsPath = '/recitation-sessions';
  static String studentNextSessionPath(int studentId) => '/students/$studentId/next-session';
  static String recitationSessionErrorsPath(int sessionId) =>
      '/recitation-sessions/$sessionId/errors';
  static String recitationSessionStatusPath(int sessionId) =>
      '/recitation-sessions/$sessionId/status';
  static String studentRecitationHistoryPath(int studentId) =>
      '/students/$studentId/recitation-history';
}
