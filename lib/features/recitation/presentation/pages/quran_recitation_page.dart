// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../../core/constants/quran_surah_names.dart';
// import '../../../../core/theme/app_dimensions.dart';
// import '../../../../core/theme/quran_accent_colors.dart';
// import '../../../../core/widgets/app_button.dart';
// import '../../../../core/widgets/app_card.dart';
// import '../../../../core/widgets/app_text_field.dart';
// import '../../../dashboard/data/repositories/teacher_repository.dart';
// import '../../data/repositories/recitation_repository.dart';
// import '../../domain/entities/quran_page_entity.dart';
// import '../../domain/entities/recitation_error_entity.dart';
// import '../widgets/highlightable_word.dart';
// import '../widgets/recitation_action_bar.dart';
// import '../widgets/recitation_top_bar.dart';

// /// صفحة "المصحف" الخاصة بجلسة التسميع — مربوطة بالكامل مع
// /// RecitationSessionController بالباك ايند:
// ///   GET  /students/{id}/next-session          → جلب الجلسة القادمة + نص صفحاتها
// ///   POST /recitation-sessions                  → إنشاء جلسة جديدة (لو ما في قادمة)
// ///   POST /recitation-sessions/{id}/errors       → حفظ تظليل الأخطاء
// ///   PATCH /recitation-sessions/{id}/status      → قبول/رفض/إعذار الجلسة
// class QuranRecitationPage extends StatefulWidget {
//   const QuranRecitationPage({super.key, required this.studentId, required this.studentName});

//   final int studentId;
//   final String studentName;

//   @override
//   State<QuranRecitationPage> createState() => _QuranRecitationPageState();
// }

// enum _LoadStatus { loading, noUpcomingSession, ready, error }

// class _QuranRecitationPageState extends State<QuranRecitationPage> {
//   final RecitationRepository _repository = RecitationRepository();
//   final TeacherRepository _teacherRepository = TeacherRepository();
//   final TextEditingController _fromPageController = TextEditingController();
//   final TextEditingController _toPageController = TextEditingController();

//   _LoadStatus _status = _LoadStatus.loading;
//   String? _errorMessage;
//   NextSessionResult? _result;
//   bool _submitting = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadNextSession();
//   }

//   @override
//   void dispose() {
//     _fromPageController.dispose();
//     _toPageController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadNextSession() async {
//     setState(() => _status = _LoadStatus.loading);
//     try {
//       final result = await _repository.getNextSession(widget.studentId);
//       setState(() {
//         _result = result;
//         _status = _LoadStatus.ready;
//       });
//     } catch (e) {
//       final message = e.toString();
//       // next-session بيرجع 404 لما ما في تسميع قادم مجدول أصلاً —
//       // هاي مو خطأ فعلي، إنما حالة طبيعية لازم الأنسة تبدأ فيها جلسة جديدة.
//       if (message.contains('404')) {
//         setState(() => _status = _LoadStatus.noUpcomingSession);
//       } else {
//         setState(() {
//           _status = _LoadStatus.error;
//           _errorMessage = message;
//         });
//       }
//     }
//   }

//   Future<void> _createSessionAndReload(int fromPage, int toPage) async {
//     setState(() => _submitting = true);
//     try {
//       final teacherId = await _teacherRepository.getMyTeacherId();
//       if (teacherId == null) {
//         throw Exception(
//           'ما قدرنا نحدد رقم حسابك (الأنسة) — تأكدي إنو عندك طالبة وحدة ع '
//           'الأقل مسجّلة، لأنو الباك ايند ما بيرجّع هاد الرقم إلا من خلال بيانات طالبة.',
//         );
//       }
//       await _repository.createSession(
//         studentId: widget.studentId,
//         teacherId: teacherId,
//         fromPage: fromPage,
//         toPage: toPage,
//       );
//       await _loadNextSession();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('تعذّر إنشاء الجلسة: $e')));
//     } finally {
//       if (mounted) setState(() => _submitting = false);
//     }
//   }

//   void _setHighlight(int pageIndex, int lineIndex, int wordIndex, WordHighlightColor color) {
//     setState(() {
//       _result!.pages[pageIndex].lines[lineIndex].words[wordIndex].highlight = color;
//     });
//   }

//   List<RecitationErrorEntity> _collectErrors() {
//     final errors = <RecitationErrorEntity>[];
//     for (final page in _result!.pages) {
//       for (final line in page.lines) {
//         for (final word in line.words) {
//           if (word.highlight == WordHighlightColor.none) continue;
//           errors.add(
//             RecitationErrorEntity(
//               wordId: word.wordId,
//               surahNumber: word.surah,
//               ayahNumber: word.ayah,
//               errorType: word.highlight,
//             ),
//           );
//         }
//       }
//     }
//     return errors;
//   }

//   Future<void> _finishSession(String status, String successMessage) async {
//     if (_result == null || _submitting) return;
//     setState(() => _submitting = true);
//     try {
//       final sessionId = _result!.session.id;
//       await _repository.submitErrors(sessionId, _collectErrors());
//       await _repository.updateStatus(sessionId, status);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
//       Navigator.of(context).pop();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حصل خطأ: $e')));
//       setState(() => _submitting = false);
//     }
//   }

//   void _handleAccepted() => _finishSession('accepted', 'تم تسجيل التسميع كمقبول');
//   void _handleRejected() => _finishSession('rejected', 'تم تسجيل التسميع كغير مقبول');
//   void _handleCancelled() => _finishSession('excused', 'تم تسجيل الجلسة كمعذورة');

//   @override
//   Widget build(BuildContext context) {
//     switch (_status) {
//       case _LoadStatus.loading:
//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//       case _LoadStatus.error:
//         return _buildMessageScaffold(
//           message: 'تعذّر تحميل جلسة التسميع:\n$_errorMessage',
//           actionLabel: 'إعادة المحاولة',
//           onAction: _loadNextSession,
//         );
//       case _LoadStatus.noUpcomingSession:
//         return _buildCreateSessionScaffold();
//       case _LoadStatus.ready:
//         return _buildReadyScaffold();
//     }
//   }

//   Widget _buildMessageScaffold({
//     required String message,
//     required String actionLabel,
//     required VoidCallback onAction,
//   }) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.studentName)),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(AppSpacing.lg),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(message, textAlign: TextAlign.center),
//               const SizedBox(height: AppSpacing.lg),
//               AppButton(label: actionLabel, onPressed: onAction),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// ما في تسميع قادم مجدول أصلاً لهاي الطالبة — الأنسة بتحدد نطاق
//   /// صفحات جديد (من - إلى) وتبدأ جلسة جديدة عبر POST /recitation-sessions.
//   Widget _buildCreateSessionScaffold() {
//     return Scaffold(
//       appBar: AppBar(title: Text('${widget.studentName} — تسميع جديد')),
//       // SingleChildScrollView ضروري هون: لما الكيبورد يفتح فوق حقول
//       // الإدخال، Scaffold بيصغّر المساحة المتاحة، وبدون سكرول الـ
//       // Column كانت تفيض (overflow) وترمي خطأ RenderFlex بالضبط متل
//       // اللي طلع معك.
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(AppSpacing.lg),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'ما في تسميع قادم مجدول لهاي الطالبة حالياً. حددي نطاق الصفحات '
//               'لبدء جلسة تسميع جديدة:',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             const SizedBox(height: AppSpacing.lg),
//             AppTextField(
//               controller: _fromPageController,
//               label: 'من صفحة',
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: AppSpacing.md),
//             AppTextField(
//               controller: _toPageController,
//               label: 'إلى صفحة',
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: AppSpacing.xl),
//             AppButton(
//               label: _submitting ? 'جاري الإنشاء...' : 'بدء التسميع',
//               onPressed: _submitting
//                   ? null
//                   : () {
//                       final from = int.tryParse(_fromPageController.text.trim());
//                       final to = int.tryParse(_toPageController.text.trim());
//                       if (from == null || to == null || to < from) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('أدخلي نطاق صفحات صحيح')),
//                         );
//                         return;
//                       }
//                       _createSessionAndReload(from, to);
//                     },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReadyScaffold() {
//     final result = _result!;
//     final firstSurah = result.pages.isNotEmpty && result.pages.first.lines.isNotEmpty
//         ? result.pages.first.lines.first.surahNumber
//         : 0;

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(88),
//         child: RecitationTopBar(
//           surahName: quranSurahLabel(firstSurah),
//           fromPage: result.session.fromPage,
//           toPage: result.session.toPage,
//           studentName: widget.studentName,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(AppSpacing.lg),
//         child: Column(
//           children: [
//             for (int pageIndex = 0; pageIndex < result.pages.length; pageIndex++)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: AppSpacing.lg),
//                 child: _buildPageCard(pageIndex, result.pages[pageIndex]),
//               ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: AbsorbPointer(
//         absorbing: _submitting,
//         child: Opacity(
//           opacity: _submitting ? 0.5 : 1,
//           child: RecitationActionBar(
//             onAccepted: _handleAccepted,
//             onRejected: _handleRejected,
//             onCancelled: _handleCancelled,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPageCard(int pageIndex, QuranPageEntity page) {
//     return AppCard(
//       padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
//       child: Column(
//         children: [
//           if (pageIndex == 0) ...[_buildBasmalaPill(context), const SizedBox(height: AppSpacing.xl)],
//           for (int lineIndex = 0; lineIndex < page.lines.length; lineIndex++)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 6),
//               child: Wrap(
//                 alignment: page.lines[lineIndex].isCentered
//                     ? WrapAlignment.center
//                     : WrapAlignment.start,
//                 runSpacing: 16,
//                 spacing: 6,
//                 textDirection: TextDirection.rtl,
//                 children: [
//                   for (
//                     int wordIndex = 0;
//                     wordIndex < page.lines[lineIndex].words.length;
//                     wordIndex++
//                   )
//                     HighlightableWord(
//                       text: page.lines[lineIndex].words[wordIndex].text,
//                       highlight: page.lines[lineIndex].words[wordIndex].highlight,
//                       onChanged: (color) =>
//                           _setHighlight(pageIndex, lineIndex, wordIndex, color),
//                     ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   /// شارة "بسم الله الرحمن الرحيم" العلوية — نفس شكل التصميم المرجعي.
//   Widget _buildBasmalaPill(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
//       decoration: BoxDecoration(
//         color: scheme.secondaryContainer.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(AppRadius.full),
//       ),
//       child: Text(
//         'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
//         style: GoogleFonts.amiri(fontSize: 22, color: scheme.primary, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/quran_surah_names.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/quran_accent_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/repositories/recitation_repository.dart';
import '../../domain/entities/quran_page_entity.dart';
import '../../domain/entities/recitation_error_entity.dart';
import '../widgets/highlightable_word.dart';
import '../widgets/recitation_action_bar.dart';
import '../widgets/recitation_top_bar.dart';

/// صفحة "المصحف" الخاصة بجلسة التسميع — مربوطة بالكامل مع
/// RecitationSessionController بالباك ايند:
///   GET  /students/{id}/next-session          → جلب الجلسة القادمة + نص صفحاتها
///   POST /recitation-sessions/{id}/errors       → حفظ تظليل الأخطاء
///   PATCH /recitation-sessions/{id}/status      → قبول/رفض/إعذار الجلسة
///
/// ملاحظة: الأنسة ما عاد فيها تنشئ جلسة تسميع يدوياً لطالبة من هون —
/// إنشاء الجلسة صار حصراً من جهة الطالبة نفسها (تسجيل ورد اليوم
/// بصفحتها الرئيسية، عبر RecitationRepository.logDailyWird)، لأنو
/// الباك ايند (RecitationSessionController@store) مبني حصراً لهاد
/// السيناريو ($request->user()->student). الأنسة هون بس بتراجع وتصحح
/// جلسة موجودة أصلاً (upcoming).
class QuranRecitationPage extends StatefulWidget {
  const QuranRecitationPage({super.key, required this.studentId, required this.studentName});

  final int studentId;
  final String studentName;

  @override
  State<QuranRecitationPage> createState() => _QuranRecitationPageState();
}

enum _LoadStatus { loading, noUpcomingSession, ready, error }

class _QuranRecitationPageState extends State<QuranRecitationPage> {
  final RecitationRepository _repository = RecitationRepository();
  final PageController _pageController = PageController();

  _LoadStatus _status = _LoadStatus.loading;
  String? _errorMessage;
  NextSessionResult? _result;
  bool _submitting = false;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadNextSession();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadNextSession() async {
    setState(() => _status = _LoadStatus.loading);
    try {
      final result = await _repository.getNextSession(widget.studentId);
      setState(() {
        _result = result;
        _status = _LoadStatus.ready;
        _currentPageIndex = 0;
      });
      if (_pageController.hasClients) _pageController.jumpToPage(0);
    } catch (e) {
      final message = e.toString();
      // next-session بيرجع 404 لما ما في تسميع قادم مجدول أصلاً —
      // هاي مو خطأ، إنما حالة طبيعية لحد ما الطالبة تسجّل وردها.
      if (message.contains('404')) {
        setState(() => _status = _LoadStatus.noUpcomingSession);
      } else {
        setState(() {
          _status = _LoadStatus.error;
          _errorMessage = message;
        });
      }
    }
  }

  void _setHighlight(int pageIndex, int lineIndex, int wordIndex, WordHighlightColor color) {
    setState(() {
      _result!.pages[pageIndex].lines[lineIndex].words[wordIndex].highlight = color;
    });
  }

  List<RecitationErrorEntity> _collectErrors() {
    final errors = <RecitationErrorEntity>[];
    for (final page in _result!.pages) {
      for (final line in page.lines) {
        for (final word in line.words) {
          if (word.highlight == WordHighlightColor.none) continue;
          errors.add(
            RecitationErrorEntity(
              wordId: word.wordId,
              surahNumber: word.surah,
              ayahNumber: word.ayah,
              errorType: word.highlight,
            ),
          );
        }
      }
    }
    return errors;
  }

  Future<void> _finishSession(String status, String successMessage) async {
    if (_result == null || _submitting) return;
    setState(() => _submitting = true);
    try {
      final sessionId = _result!.session.id;
      await _repository.submitErrors(sessionId, _collectErrors());
      await _repository.updateStatus(sessionId, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حصل خطأ: $e')));
      setState(() => _submitting = false);
    }
  }

  void _handleAccepted() => _finishSession('accepted', 'تم تسجيل التسميع كمقبول');
  void _handleRejected() => _finishSession('rejected', 'تم تسجيل التسميع كغير مقبول');

  /// إلغاء = إغلاق فقط، ولا نداء للباك اند. الجلسة تضل upcoming كما
  /// هي (نفس الطالبة نفسها أنشأتها)، فبتقدر الأنسة ترجع تفوت عليها
  /// لاحقاً - GET next-session بيرجّعها نفسها لأنها لسا upcoming.
  void _handleCancelled() {
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _LoadStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case _LoadStatus.error:
        return _buildMessageScaffold(
          message: 'تعذّر تحميل جلسة التسميع:\n$_errorMessage',
          actionLabel: 'إعادة المحاولة',
          onAction: _loadNextSession,
        );
      case _LoadStatus.noUpcomingSession:
        return _buildNoUpcomingSessionScaffold();
      case _LoadStatus.ready:
        return _buildReadyScaffold();
    }
  }

  Widget _buildMessageScaffold({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.studentName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: actionLabel, onPressed: onAction),
            ],
          ),
        ),
      ),
    );
  }

  /// ما في تسميع قادم مجدول أصلاً لهاي الطالبة — هاد وضع طبيعي
  /// (مش خطأ)، وبيصير عادة قبل ما الطالبة تسجّل وردها اليومي. إنشاء
  /// الجلسة صار حصراً من جهة الطالبة (زر "تسجيل ورد اليوم" بصفحتها
  /// الرئيسية)، فهون بس نعرض حالة انتظار + زر تحديث يدوي.
  Widget _buildNoUpcomingSessionScaffold() {
    return Scaffold(
      appBar: AppBar(title: Text(widget.studentName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: AppSpacing.md),
             Text(
                'لا يوجد تسميع مجدول لهذه الطالبة حالياً.\n'
                'سيصبح التسميع متاحاً هنا بعد أن تسجّل الطالبة وِردها اليومي '
                'من صفحتها الرئيسية.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: 'تحديث', onPressed: _loadNextSession),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadyScaffold() {
    final result = _result!;
    final firstSurah = result.pages.isNotEmpty && result.pages.first.lines.isNotEmpty
        ? result.pages.first.lines.first.surahNumber
        : 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: RecitationTopBar(
          surahName: quranSurahLabel(firstSurah),
          fromPage: result.session.fromPage,
          toPage: result.session.toPage,
          studentName: widget.studentName,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: result.pages.length,
              onPageChanged: (index) => setState(() => _currentPageIndex = index),
              itemBuilder: (context, pageIndex) {
                // كل صفحة بسكرول خاص فيها لحالها — لو محتوى الصفحة
                // (عدد الأسطر) أطول من المساحة المتاحة عالشاشة، ما
                // بينقص منها شي، هي بس تصير قابلة للسكرول لحالها
                // بدل ما نعتمد على سكرول واحد عام لكل الصفحات.
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _buildPageCard(pageIndex, result.pages[pageIndex]),
                );
              },
            ),
          ),
          if (result.pages.length > 1) _buildPageIndicator(result.pages.length),
        ],
      ),
      bottomNavigationBar: AbsorbPointer(
        absorbing: _submitting,
        child: Opacity(
          opacity: _submitting ? 0.5 : 1,
          child: RecitationActionBar(
            onAccepted: _handleAccepted,
            onRejected: _handleRejected,
            onCancelled: _handleCancelled,
          ),
        ),
      ),
    );
  }

  /// شريط "صفحة X من Y" + نقاط تدل على موقع الصفحة الحالية بين
  /// صفحات التسميع — يظهر بس لما يكون في أكتر من صفحة وحدة، تحت
  /// الـ PageView مباشرة وفوق شريط أزرار القبول/الرفض.
  Widget _buildPageIndicator(int pageCount) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      color: scheme.surfaceContainerLow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'صفحة ${_currentPageIndex + 1} من $pageCount',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < pageCount; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _currentPageIndex ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _currentPageIndex ? scheme.primary : scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageCard(int pageIndex, QuranPageEntity page) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: Column(
        children: [
          if (pageIndex == 0) ...[_buildBasmalaPill(context), const SizedBox(height: AppSpacing.xl)],
          for (int lineIndex = 0; lineIndex < page.lines.length; lineIndex++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Wrap(
                alignment: page.lines[lineIndex].isCentered
                    ? WrapAlignment.center
                    : WrapAlignment.start,
                runSpacing: 16,
                spacing: 6,
                textDirection: TextDirection.rtl,
                children: [
                  for (
                    int wordIndex = 0;
                    wordIndex < page.lines[lineIndex].words.length;
                    wordIndex++
                  )
                    HighlightableWord(
                      text: page.lines[lineIndex].words[wordIndex].text,
                      highlight: page.lines[lineIndex].words[wordIndex].highlight,
                      onChanged: (color) =>
                          _setHighlight(pageIndex, lineIndex, wordIndex, color),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// شارة "بسم الله الرحمن الرحيم" العلوية — نفس شكل التصميم المرجعي.
  Widget _buildBasmalaPill(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        style: GoogleFonts.amiri(fontSize: 22, color: scheme.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}