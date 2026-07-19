
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../models/student_model.dart';

class TeacherDashboardData {
  const TeacherDashboardData({required this.students, required this.stats});
  final List<StudentModel> students;
  final DashboardStatsEntity stats;
}

class TeacherRepository {
  TeacherRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  Future<List<StudentModel>> getStudents() async {
    final response = await _apiClient.get(AppConfig.teacherStudentsPath);
    final data = response.data as Map<String, dynamic>;
    final list = (data['students'] as List<dynamic>?) ?? const [];
    return list.map((json) => StudentModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<int> getStudentsCount() async {
    final response = await _apiClient.get(AppConfig.teacherStudentsCountPath);
    final data = response.data as Map<String, dynamic>;
    return (data['students_number'] as num?)?.toInt() ?? 0;
  }

  Future<int> getGroupAchievementParts() async {
    final response = await _apiClient.get(AppConfig.teacherGroupAchievementPath);
    final data = response.data as Map<String, dynamic>;
    return (data['accepted_parts'] as num?)?.toInt() ?? 0;
  }

  Future<int> getActiveStudentsCount() async {
    final response = await _apiClient.get(AppConfig.teacherActiveStudentsPath);
    final list = (response.data as List<dynamic>?) ?? const [];
    return list.length;
  }

  /// TeachersController@searchStudentById → GET /teacher/student/{id}
  Future<Map<String, dynamic>> getStudentById(int id) async {
    final response = await _apiClient.get('${AppConfig.teacherStudentByIdPath}/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<TeacherDashboardData> loadDashboard() async {
    final students = await getStudents();
    final totalStudents = await getStudentsCount();
    final groupAchievementParts = await getGroupAchievementParts();
    final activeStudents = await getActiveStudentsCount();

    return TeacherDashboardData(
      students: students,
      stats: DashboardStatsEntity(
        totalStudents: totalStudents,
        groupAchievementParts: groupAchievementParts,
        activeStudents: activeStudents,
      ),
    );
  }
}