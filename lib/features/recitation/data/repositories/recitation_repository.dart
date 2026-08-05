// import '../../../../core/config/app_config.dart';
// import '../../../../core/network/api_client.dart';
// import '../../domain/entities/quran_page_entity.dart';
// import '../../domain/entities/recitation_error_entity.dart';
// import '../../domain/entities/recitation_session_entity.dart';

// /// نتيجة GET /students/{id}/next-session: الجلسة القادمة + صفحاتها
// /// الفعلية (نص المصحف كامل، جاهز للعرض والتلوين).
// class NextSessionResult {
//   const NextSessionResult({required this.session, required this.pages});
//   final RecitationSessionEntity session;
//   final List<QuranPageEntity> pages;
// }

// /// طبقة الوصول الكاملة لـ RecitationSessionController بالباك ايند —
// /// كل توابع جلسات التسميع (إنشاء/جلب القادم/حفظ الأخطاء/تحديث الحالة/
// /// السجل) من مكان واحد، بدل ما تتوزع نداءات Dio مباشرة داخل الواجهات.
// class RecitationRepository {
//   RecitationRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

//   final ApiClient _apiClient;

//   /// POST /recitation-sessions — تُستخدم لما ما في تسميع قادم مجدول
//   /// أصلاً للطالبة (next-session بيرجع 404)، فالأنسة تحدد نطاق صفحات
//   /// جديد وتبدأ جلسة جديدة بحالة "upcoming".
//   ///
//   /// ⚠️ teacherId إلزامي بالباك ايند (StoreRecitationSessionRequest:
//   /// 'teacher_id' => 'required|exists:teachers,id') — لو ما انبعت كان
//   /// السبب المباشر لخطأ 422 اللي طلع. هاد الرقم ييجي من
//   /// TeacherRepository.getMyTeacherId() مش من إدخال يدوي.
//   Future<RecitationSessionEntity> createSession({
//     required int studentId,
//     required int teacherId,
//     required int fromPage,
//     required int toPage,
//     String? scheduledDate,
//   }) async {
//     final response = await _apiClient.post(
//       AppConfig.recitationSessionsPath,
//       data: {
//         'student_id': studentId,
//         'teacher_id': teacherId,
//         'from_page': fromPage,
//         'to_page': toPage,
//         if (scheduledDate != null) 'scheduled_date': scheduledDate,
//       },
//     );
//     return RecitationSessionEntity.fromJson(response.data as Map<String, dynamic>);
//   }

//   Future<RecitationSessionEntity> logDailyWird({
//     required int fromPage,
//     required int toPage,
//   }) async {
//     final today = DateTime.now();
//     final scheduledDate =
//         '${today.year.toString().padLeft(4, '0')}-'
//         '${today.month.toString().padLeft(2, '0')}-'
//         '${today.day.toString().padLeft(2, '0')}';

//     final response = await _apiClient.post(
//       AppConfig.recitationSessionsPath,
//       data: {
//         'from_page': fromPage,
//         'to_page': toPage,
//         'scheduled_date': scheduledDate,
//       },
//     );
//     return RecitationSessionEntity.fromJson(response.data as Map<String, dynamic>);
//   }

//   /// GET /students/{id}/next-session — الجلسة القادمة (upcoming) مع
//   /// نص صفحاتها كامل. بترمي استثناء لو رجع 404 (ما في تسميع قادم بعد).
//   Future<NextSessionResult> getNextSession(int studentId) async {
//     final response = await _apiClient.get(AppConfig.studentNextSessionPath(studentId));
//     final data = response.data as Map<String, dynamic>;
//     return NextSessionResult(
//       session: RecitationSessionEntity.fromJson(data['session'] as Map<String, dynamic>),
//       pages: QuranPageEntity.listFromPagesJson(data['pages'] as Map<String, dynamic>),
//     );
//   }

//   /// POST /recitation-sessions/{id}/errors — تُرسل فقط الكلمات
//   /// المظلَّلة فعلياً (بدون "none")، بنفس شكل StoreRecitationErrorsRequest.
//   Future<void> submitErrors(int sessionId, List<RecitationErrorEntity> errors) async {
//     if (errors.isEmpty) return; // الباك ايند يرفض 'errors' فاضية (min:1)
//     await _apiClient.post(
//       AppConfig.recitationSessionErrorsPath(sessionId),
//       data: {'errors': errors.map((e) => e.toJson()).toList()},
//     );
//   }

//   /// PATCH /recitation-sessions/{id}/status — accepted/rejected/excused.
//   Future<RecitationSessionEntity> updateStatus(int sessionId, String status) async {
//     final response = await _apiClient.patch(
//       AppConfig.recitationSessionStatusPath(sessionId),
//       data: {'status': status},
//     );
//     return RecitationSessionEntity.fromJson(response.data as Map<String, dynamic>);
//   }

//   /// GET /students/{id}/recitation-history — كل جلسات الطالبة (سجل
//   /// إنجازاتها الكامل، مرتب من الأحدث للأقدم).
//   Future<List<RecitationSessionEntity>> getHistory(int studentId) async {
//     final response = await _apiClient.get(AppConfig.studentRecitationHistoryPath(studentId));
//     final list = (response.data as List<dynamic>?) ?? const [];
//     return list
//         .map((json) => RecitationSessionEntity.fromJson(json as Map<String, dynamic>))
//         .toList();
//   }

//   /// POST /recitation-sessions/show — صفحات المصحف الخاصة بتسميع
//   /// معيّن (session بالماضي أو الحاضر)، مع error_type لكل كلمة إذا
//   /// كانت الأنسة سجّلت أخطاء عليها وقت التسميع. تُستخدم بصفحة
//   /// "تسميعاتي" عند الطالبة (مراجعة تسميع سابق بوضع readOnly).
//   Future<List<QuranPageEntity>> getSessionReview(int sessionId) async {
//     final response = await _apiClient.post(
//       AppConfig.recitationSessionShowPath,
//       data: {'recitation_session_id': sessionId},
//     );
//     final data = response.data as Map<String, dynamic>;
//     return QuranPageEntity.listFromPagesJson(data['pages'] as Map<String, dynamic>);
//   }
// }



import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/mawdi_entity.dart';
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

/// نتيجة POST /recitation-sessions/show: صفحات التسميع + مواضع
/// "التبيان المفصل" المرتبطة بكل صفحة (mawadi_by_page)، منفصلة عن
/// pages عمداً — الصفحة نفسها (quran_words) شي، والموضع المستخرج من
/// كتاب خارجي عبر الـ OCR شي تاني، وربطهم برقم الصفحة كفتاح Map هو
/// اللي بيسمح للواجهة تعرض كل موضع تحت صفحته مباشرة بلا أي منطق
/// مطابقة إضافي بجانب العرض.
class SessionReviewResult {
  const SessionReviewResult({required this.pages, required this.mawadiByPage});
  final List<QuranPageEntity> pages;
  final Map<int, List<MawdiEntity>> mawadiByPage;
}

/// طبقة الوصول الكاملة لـ RecitationSessionController بالباك ايند —
/// كل توابع جلسات التسميع (جلب القادم/حفظ الأخطاء/تحديث الحالة/
/// السجل) من مكان واحد، بدل ما تتوزع نداءات Dio مباشرة داخل الواجهات.
///
/// ملاحظة: ما في هون دالة "إنشاء جلسة من طرف الأنسة" — إنشاء الجلسة
/// (POST /recitation-sessions) صار حصراً عبر logDailyWird تحت، تُستدعى
/// من الطالبة نفسها (الباك ايند RecitationSessionController@store
/// مبني حصراً لهاد السيناريو: $request->user()->student).
class RecitationRepository {
  RecitationRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  Future<RecitationSessionEntity> logDailyWird({
    required int fromPage,
    required int toPage,
  }) async {
    final today = DateTime.now();
    final scheduledDate =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    final response = await _apiClient.post(
      AppConfig.recitationSessionsPath,
      data: {
        'from_page': fromPage,
        'to_page': toPage,
        'scheduled_date': scheduledDate,
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

  /// DELETE /recitation-sessions/{id} — حذف نهائي (مش إلغاء). تُستخدم
  /// لما الأنسة تختار "حذف نهائياً" من حوار زر إلغاء، بالتسميع العادي
  /// وبالسبر الذكي معاً (نفس جدول recitation_sessions بالضبط).
  Future<void> deleteSession(int sessionId) async {
    await _apiClient.delete(AppConfig.recitationSessionDeletePath(sessionId));
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

  /// POST /recitation-sessions/show — صفحات المصحف الخاصة بتسميع
  /// معيّن (session بالماضي أو الحاضر)، مع error_type لكل كلمة إذا
  /// كانت الأنسة سجّلت أخطاء عليها وقت التسميع، بالإضافة لـ
  /// mawadi_by_page (مواضع "التبيان المفصل" المرتبطة بالأخطاء الحمرا
  /// فقط، عبر جدول word_colors بالباك ايند). تُستخدم بصفحة
  /// "تسميعاتي" عند الطالبة (مراجعة تسميع سابق بوضع readOnly).
  Future<SessionReviewResult> getSessionReview(int sessionId) async {
    final response = await _apiClient.post(
      AppConfig.recitationSessionShowPath,
      data: {'recitation_session_id': sessionId},
    );
    final data = response.data as Map<String, dynamic>;
    return SessionReviewResult(
      pages: QuranPageEntity.listFromPagesJson(data['pages'] as Map<String, dynamic>),
      // مفتاح غايب بالكامل لو الباك ايند القديم (قبل رفع التعديل)
      // لسا شغال، أو لو الجلسة ما فيها ولا خطأ أحمر مرتبط بموضع.
      mawadiByPage: MawdiEntity.mapFromJson(data['mawadi_by_page'] as Map<String, dynamic>?),
    );
  }
}