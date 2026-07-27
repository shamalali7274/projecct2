import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/quran_page_entity.dart';
import '../../domain/entities/recitation_error_entity.dart';
import '../../domain/entities/recitation_session_entity.dart';

/// نتيجة GET /students/{id}/next-session: الجلسة القادمة + صفحاتها
/// الفعلية (نص المصحف كامل، جاهز للعرض والتلوين).
class NextSessionResult {
  const NextSessionResult({required this.session, required this.pages});
  final RecitationSessionEntity session;
  final List<QuranPageEntity> pages;
}

/// طبقة الوصول الكاملة لـ RecitationSessionController بالباك ايند —
/// كل توابع جلسات التسميع (إنشاء/جلب القادم/حفظ الأخطاء/تحديث الحالة/
/// السجل) من مكان واحد، بدل ما تتوزع نداءات Dio مباشرة داخل الواجهات.
class RecitationRepository {
  RecitationRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  /// POST /recitation-sessions — تُستخدم لما ما في تسميع قادم مجدول
  /// أصلاً للطالبة (next-session بيرجع 404)، فالأنسة تحدد نطاق صفحات
  /// جديد وتبدأ جلسة جديدة بحالة "upcoming".
  Future<RecitationSessionEntity> createSession({
    required int studentId,
    required int fromPage,
    required int toPage,
    String? scheduledDate,
  }) async {
    final response = await _apiClient.post(
      AppConfig.recitationSessionsPath,
      data: {
        'student_id': studentId,
        'from_page': fromPage,
        'to_page': toPage,
        if (scheduledDate != null) 'scheduled_date': scheduledDate,
      },
    );
    return RecitationSessionEntity.fromJson(response.data as Map<String, dynamic>);
  }

  /// GET /students/{id}/next-session — الجلسة القادمة (upcoming) مع
  /// نص صفحاتها كامل. بترمي استثناء لو رجع 404 (ما في تسميع قادم بعد).
  Future<NextSessionResult> getNextSession(int studentId) async {
    final response = await _apiClient.get(AppConfig.studentNextSessionPath(studentId));
    final data = response.data as Map<String, dynamic>;
    return NextSessionResult(
      session: RecitationSessionEntity.fromJson(data['session'] as Map<String, dynamic>),
      pages: QuranPageEntity.listFromPagesJson(data['pages'] as Map<String, dynamic>),
    );
  }

  /// POST /recitation-sessions/{id}/errors — تُرسل فقط الكلمات
  /// المظلَّلة فعلياً (بدون "none")، بنفس شكل StoreRecitationErrorsRequest.
  Future<void> submitErrors(int sessionId, List<RecitationErrorEntity> errors) async {
    if (errors.isEmpty) return; // الباك ايند يرفض 'errors' فاضية (min:1)
    await _apiClient.post(
      AppConfig.recitationSessionErrorsPath(sessionId),
      data: {'errors': errors.map((e) => e.toJson()).toList()},
    );
  }

  /// PATCH /recitation-sessions/{id}/status — accepted/rejected/excused.
  Future<RecitationSessionEntity> updateStatus(int sessionId, String status) async {
    final response = await _apiClient.patch(
      AppConfig.recitationSessionStatusPath(sessionId),
      data: {'status': status},
    );
    return RecitationSessionEntity.fromJson(response.data as Map<String, dynamic>);
  }

  /// GET /students/{id}/recitation-history — كل جلسات الطالبة (سجل
  /// إنجازاتها الكامل، مرتب من الأحدث للأقدم).
  Future<List<RecitationSessionEntity>> getHistory(int studentId) async {
    final response = await _apiClient.get(AppConfig.studentRecitationHistoryPath(studentId));
    final list = (response.data as List<dynamic>?) ?? const [];
    return list
        .map((json) => RecitationSessionEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
