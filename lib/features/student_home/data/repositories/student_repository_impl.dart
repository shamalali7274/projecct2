import 'package:academic_concourse_for_girls/features/student_home/domain/enities/student_dashboard_entity.dart';
import 'package:academic_concourse_for_girls/features/student_home/domain/repo/student_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
/// Endpoints مؤكدة من StudentsController الفعلي بالباك اند:
///   GET /students/info                         -> { full_name, goal, path, college }
///   GET /students/achievement_relation_to_goal  -> { achievement, goal }
///   GET /students/ranking                       -> { ranking }
///   GET /students/college-ranking                -> { college_ranking }
///   GET /students/path-ranking                   -> { path_ranking }
///
/// الكل محمي بـ auth:sanctum — بلا أي كود إضافي هون لإرسال التوكن،
/// لأنه الـ AuthInterceptor بـ ApiClient بيلزقّه تلقائياً لأي request.
class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;
  final Dio _dio;

  @override
  Future<StudentDashboardEntity> getDashboard() async {
    try {
      // الـ 5 نداءات مع بعض بالتوازي (مو الواحد وراء التاني) — أسرع
      // بكثير من 5 await متتالية لأنها كلها محتاجة لنفس الشاشة.
      final responses = await Future.wait([
        _dio.get('/students/info'),
        _dio.get('/students/achievement_relation_to_goal'),
        _dio.get('/students/ranking'),
        _dio.get('/students/college-ranking'),
        _dio.get('/students/path-ranking'),
      ]);

      final info = responses[0].data as Map<String, dynamic>;
      final achievementData = responses[1].data as Map<String, dynamic>;
      final ranking = responses[2].data as Map<String, dynamic>;
      final collegeRanking = responses[3].data as Map<String, dynamic>;
      final pathRanking = responses[4].data as Map<String, dynamic>;

      return StudentDashboardEntity(
        fullName: info['full_name'] as String? ?? '',
        goal: (info['goal'] as num?)?.toInt() ?? 0,
        path: info['path'] as String? ?? '',
        college: info['college'] as String? ?? '',
        achievement: (achievementData['achievement'] as num?)?.toInt() ?? 0,
        ranking: (ranking['ranking'] as num?)?.toInt() ?? 0,
        collegeRanking:
            (collegeRanking['college_ranking'] as num?)?.toInt() ?? 0,
        pathRanking: (pathRanking['path_ranking'] as num?)?.toInt() ?? 0,
      );
    } on DioException catch (e) {
      throw ServerException(_mapDioError(e));
    }
  }

  String _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401) return 'انتهت صلاحية الجلسة، الرجاء تسجيل الدخول مجدداً';
    if (status == 404) return 'بيانات الطالبة غير موجودة';
    return 'تعذّر تحميل بيانات اللوحة، حاولي مرة أخرى';
  }
}
