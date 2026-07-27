
import 'package:flutter/material.dart';
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

  /// لا يوجد بالباك ايند أي endpoint يرجّع "معرّف الأنسة الحالية"
  /// (Teacher.id) مباشرة من التوكن — بس هاد الرقم موجود جاهز بأي
  /// طالبة تابعة لها (عمود teacher_id الخام بجدول students). فمنخزّنه
  /// أول ما توصل أي استجابة فيها طالبة وحدة ع الأقل، ومنعيد استخدامه
  /// لاحقاً (مثلاً عند إنشاء جلسة تسميع) بدل ما نطلبه من كل صفحة.
  static int? _cachedTeacherId;

  void _cacheTeacherIdFrom(List<StudentModel> students) {
    if (_cachedTeacherId != null) return;
    for (final student in students) {
      if (student.teacherId != null) {
        _cachedTeacherId = student.teacherId;
        return;
      }
    }
  }

  /// يرجّع Teacher.id الحالي (من الكاش لو موجود، وإلا يجيب قائمة
  /// الطالبات مرة عشان يستخرجه منها).
  Future<int?> getMyTeacherId() async {
    if (_cachedTeacherId != null) return _cachedTeacherId;
    final students = await getStudents();
    _cacheTeacherIdFrom(students);
    return _cachedTeacherId;
  }

  Future<List<StudentModel>> getStudents() async {
    final response = await _apiClient.get(AppConfig.teacherStudentsPath);
    final data = response.data as Map<String, dynamic>;
    final list = (data['students'] as List<dynamic>?) ?? const [];
    final students = list
        .map((json) => StudentModel.fromJson(json as Map<String, dynamic>))
        .toList();
    _cacheTeacherIdFrom(students);
    return students;
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
  /// الشكل هون مختلف عن getStudents/getStudentByName (بدون 'achievement'
  /// ولا 'college' ولا صورة — بس بيانات تعريفية + الهدف)، فمنبنيها StudentModel
  /// يدوياً بالحقول المتوفرة فقط بدل تعديل StudentModel.fromJson العام.
  Future<StudentModel?> getStudentById(int id) async {
    try {
      final response = await _apiClient.get('${AppConfig.teacherStudentByIdPath}/$id');
      final json = response.data as Map<String, dynamic>;
      final firstName = (json['first_name'] as String?)?.trim() ?? '';
      final lastName = (json['last_name'] as String?)?.trim() ?? '';
      final name = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

      return StudentModel(
        id: json['id'].toString(),
        name: name.isEmpty ? 'بدون اسم' : name,
        membershipId: 'MLT-${json['id']}',
        college: '', // هاد الـ endpoint ما بيرجع الكلية
        avatarUrl: '',
        completedParts: 0, // ولا الإنجاز الحالي (مش موجود بهاد الـ endpoint)
        totalParts: (json['goal'] as num?)?.toDouble() ?? 0,
        lastAchievementLabel: 'الهدف: ${json['goal'] ?? 0} جزء',
        badgeIcon: Icons.verified,
      );
    } on Exception catch (e) {
      if (e.toString().contains('404')) return null;
      rethrow;
    }
  }

  /// TeachersController@getStudentByName → POST /teachers/students/name
  /// بترجع {first_name, full_name, student} أو 404 لو ما لقت تطابق.
  Future<StudentModel?> getStudentByName(String name) async {
    try {
      final response = await _apiClient.post(
        AppConfig.teacherStudentByNamePath,
        data: {'name': name},
      );
      final data = response.data as Map<String, dynamic>;
      final studentJson = data['student'] as Map<String, dynamic>;
      // الباك ايند هون بيرجّع full_name بمستوى الـ response العلوي
      // مو جوا كائن الطالبة نفسه (بعكس getStudents) — منحقنها جوا
      // studentJson قبل التحويل حتى يشتغل StudentModel.fromJson بنفس
      // منطق قراءة full_name المستخدم بكل مكان تاني.
      studentJson['full_name'] = data['full_name'];
      final student = StudentModel.fromJson(studentJson);
      _cacheTeacherIdFrom([student]);
      return student;
    } on Exception catch (e) {
      if (e.toString().contains('404')) return null;
      rethrow;
    }
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