import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/smart_recitation_session_bundle.dart';

/// طبقة الوصول الكاملة لميزة "السبر الذكي" بالباك ايند
/// (SmartRecitationController) - من مكان واحد، بنفس نمط
/// RecitationRepository تماماً.
class SmartRecitationRepository {
  SmartRecitationRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  /// GET /teacher/smart-recitation/students/{id}/upcoming — لو في
  /// جلسة سبر ذكي "upcoming" (لسا ما تقرر مصيرها) لهاي الطالبة،
  /// بترجعها مع أسئلتها المجمّدة نفسها (استئناف)، أو null لو ما في.
  Future<SmartRecitationSessionBundle?> getUpcoming(int studentId) async {
    final response = await _apiClient.get(AppConfig.smartRecitationUpcomingPath(studentId));
    final data = response.data as Map<String, dynamic>;
    if (data['session'] == null) return null;
    return SmartRecitationSessionBundle.fromJson(data);
  }

  /// POST /teacher/smart-recitation/sessions — إنشاء جلسة سبر جديدة:
  /// بترجع الجلسة وأسئلتها المقترحة معاً (مجمّدة فوراً من نفس اللحظة).
  Future<SmartRecitationSessionBundle> createSession({
    required int studentId,
    required int fromPage,
    required int toPage,
    required int count,
  }) async {
    final response = await _apiClient.post(
      AppConfig.smartRecitationSessionsPath,
      data: {'student_id': studentId, 'from_page': fromPage, 'to_page': toPage, 'count': count},
    );
    return SmartRecitationSessionBundle.fromJson(response.data as Map<String, dynamic>);
  }
}
