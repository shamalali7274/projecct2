import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../recitation/data/repositories/recitation_repository.dart';
import '../../../recitation/presentation/widgets/recitation_action_bar.dart';
import '../../data/repositories/smart_recitation_repository.dart';
import '../../domain/entities/smart_recitation_excerpt_entity.dart';
import '../../domain/entities/smart_recitation_session_bundle.dart';
import '../widgets/smart_excerpt_card.dart';
import '../widgets/smart_recitation_setup_sheet.dart';

/// شاشة "السبر الذكي": تعرض الأسئلة المقترحة سؤال سؤال (لا كلها دفعة
/// وحدة)، مع إمكانية الرجوع للسؤال السابق أو الانتقال للتالي، وبعد ما
/// تخلص الانسة مراجعة كل الأسئلة (أو بأي وقت تحب) تقرر: مقبول أو غير
/// مقبول — بيتخزن القرار بنفس recitation_sessions (عبر PATCH الموجود
/// أصلاً بـ RecitationRepository)، فبيظهر تلقائياً بسجل تسميعات
/// الطالبة مع باقي التسميعات العادية.
///
/// "إلغاء" هون مختلف عن قصد: **حذف صامت** للجلسة (بدون أي زر إضافي
/// ظاهر للانسة) - لأنه جلسة السبر الذكي كاملة من صنع النظام، فإذا
/// الانسة ما قررت مصيرها (مقبول/غير مقبول)، ما في داعي تضل موجودة
/// بالسجل إطلاقاً. هاد مختلف عن التسميع العادي (اللي الطالبة نفسها
/// بتنشئه)، حيث "إلغاء" هناك بس إغلاق بدون حذف.
class SmartRecitationSessionPage extends StatefulWidget {
  const SmartRecitationSessionPage({
    super.key,
    required this.studentId,
    required this.studentName,
    this.initialBundle,
    this.setup,
  }) : assert(
         initialBundle != null || setup != null,
         'لازم تمرري إما initialBundle (استئناف) أو setup (إنشاء جديد)',
       );

  final int studentId;
  final String studentName;

  /// جلسة موجودة أصلاً (upcoming) رح نستأنفها بنفس أسئلتها المجمّدة.
  final SmartRecitationSessionBundle? initialBundle;

  /// إعداد جلسة جديدة (من صفحة/إلى صفحة/كم سؤال) - بنستخدمه لإنشاء
  /// الجلسة لو ما في initialBundle.
  final SmartRecitationSetupResult? setup;

  @override
  State<SmartRecitationSessionPage> createState() => _SmartRecitationSessionPageState();
}

enum _LoadStatus { loading, empty, ready, error }

class _SmartRecitationSessionPageState extends State<SmartRecitationSessionPage> {
  final SmartRecitationRepository _smartRepository = SmartRecitationRepository();
  final RecitationRepository _recitationRepository = RecitationRepository();

  _LoadStatus _status = _LoadStatus.loading;
  String? _errorMessage;
  List<SmartRecitationExcerptEntity> _excerpts = const [];
  int _currentIndex = 0;
  int? _sessionId;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _status = _LoadStatus.loading;
      _errorMessage = null;
    });
    try {
      final bundle = widget.initialBundle ?? await _createNewSession();
      _applyBundle(bundle);
    } catch (e) {
      setState(() {
        _status = _LoadStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  Future<SmartRecitationSessionBundle> _createNewSession() {
    final setup = widget.setup!;
    return _smartRepository.createSession(
      studentId: widget.studentId,
      fromPage: setup.fromPage,
      toPage: setup.toPage,
      count: setup.count,
    );
  }

  void _applyBundle(SmartRecitationSessionBundle bundle) {
    if (bundle.excerpts.isEmpty) {
      setState(() => _status = _LoadStatus.empty);
      return;
    }
    setState(() {
      _excerpts = bundle.excerpts;
      _sessionId = bundle.session.id;
      _currentIndex = 0;
      _status = _LoadStatus.ready;
    });
  }

  void _goNext() {
    if (_currentIndex < _excerpts.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  Future<void> _finish(String status, String successMessage) async {
    if (_sessionId == null || _submitting) return;
    setState(() => _submitting = true);
    try {
      await _recitationRepository.updateStatus(_sessionId!, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حصل خطأ: $e')));
      setState(() => _submitting = false);
    }
  }

  void _handleAccepted() => _finish('accepted', 'تم تسجيل السبر كمقبول');
  void _handleRejected() => _finish('rejected', 'تم تسجيل السبر كغير مقبول');

  /// حذف صامت: تلقائياً بدون زر إضافي ظاهر - إلغاء السبر يعني حذفه
  /// كلياً، حتى ما يظهر بالسجل إطلاقاً إذا ما تقرر مصيره.
  Future<void> _handleCancelled() async {
    if (_sessionId == null || _submitting) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    setState(() => _submitting = true);
    try {
      await _recitationRepository.deleteSession(_sessionId!);
    } catch (_) {
      // حتى لو فشل الحذف بالباك اند، منسمح للانسة تطلع من الشاشة
      // عادي - مش لازم نعلّقها هون بسبب خطأ شبكة عابر.
    } finally {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _LoadStatus.loading:
        return Scaffold(
          appBar: AppBar(title: Text('${widget.studentName} — سبر ذكي')),
          body: const Center(child: CircularProgressIndicator()),
        );
      case _LoadStatus.error:
        return _buildMessageScaffold(
          message: 'تعذّر تحميل أسئلة السبر:\n$_errorMessage',
          actionLabel: 'إعادة المحاولة',
          onAction: _load,
        );
      case _LoadStatus.empty:
        return _buildMessageScaffold(
          message:
              'ما قدرنا نبني أي سؤال ضمن هاد المجال من الصفحات '
              '(المجال صغير جداً). جربي مجال أوسع.',
          actionLabel: 'رجوع',
          onAction: () => Navigator.of(context).pop(),
        );
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
      appBar: AppBar(title: Text('${widget.studentName} — سبر ذكي')),
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

  Widget _buildReadyScaffold() {
    final total = _excerpts.length;
    final excerpt = _excerpts[_currentIndex];
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == total - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text('${widget.studentName} — سؤال ${_currentIndex + 1} من $total'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            SmartExcerptCard(excerpt: excerpt),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'السؤال السابق',
                    variant: AppButtonVariant.outlined,
                    icon: Icons.arrow_forward_rounded, // RTL: يرجع للخلف
                    onPressed: isFirst ? null : _goPrevious,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: isLast ? 'آخر سؤال' : 'السؤال التالي',
                    variant: AppButtonVariant.filled,
                    icon: Icons.arrow_back_rounded, // RTL: يتقدّم للأمام
                    onPressed: isLast ? null : _goNext,
                  ),
                ),
              ],
            ),
          ],
        ),
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
}
