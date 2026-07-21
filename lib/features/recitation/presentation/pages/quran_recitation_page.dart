import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/quran_accent_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/quran_word_entity.dart';
import '../../domain/entities/recitation_range_entity.dart';
import '../widgets/highlightable_word.dart';
import '../widgets/recitation_action_bar.dart';
import '../widgets/recitation_top_bar.dart';

/// صفحة "المصحف" الخاصة بجلسة التسميع.
///
/// بتستخدم نفس ألوان وخط باقي التطبيق (Theme.of(context)) — بدون ثيم
/// منفصل — حتى تضل بروح المشروع نفسها، وبتدعم فاتح/داكن تلقائياً
/// لأنها ما بتفرض أي لون ثابت. الشكل هون مطابق للتصميم المرجعي
/// (شريط علوي دائري + بطاقة نص مرفوعة + أزرار دائرية سفلية) لكن
/// بألوان AppColors الخاصة بالتطبيق بدل ألوان التصميم المرجعي.
class QuranRecitationPage extends StatefulWidget {
  const QuranRecitationPage({super.key, required this.studentName, required this.range});

  final String studentName;
  final RecitationRangeEntity range;

  @override
  State<QuranRecitationPage> createState() => _QuranRecitationPageState();
}

class _QuranRecitationPageState extends State<QuranRecitationPage> {
  // TODO: نص تجريبي (سورة الفاتحة) فقط لعرض آلية التظليل — سيُستبدل
  // لاحقاً بنص المصحف الفعلي المطابق لنطاق التسميع (widget.range)
  // القادم من الباك ايند.
  late final List<QuranWordEntity> _words = _buildMockWords();

  List<QuranWordEntity> _buildMockWords() {
    const text = 'الْحَمْدُ لِلَّهِ الَّذِي أَنْزَلَ عَلَى عَبْدِهِ الْكِتَابَ '
        'وَلَمْ يَجْعَلْ لَهُ عِوَجًا قَيِّمًا لِيُنْذِرَ بَأْسًا '
        'شَدِيدًا مِنْ لَدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِينَ الَّذِينَ '
        'يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا حَسَنًا';
    final parts = text.split(' ');
    return List.generate(parts.length, (i) => QuranWordEntity(id: '$i', text: parts[i]));
  }

  void _setHighlight(int index, WordHighlightColor color) {
    setState(() => _words[index].highlight = color);
  }

  void _handleAccepted() => _finishSession('تم تسجيل التسميع كمقبول');
  void _handleRejected() => _finishSession('تم تسجيل التسميع كغير مقبول');
  void _handleCancelled() => Navigator.of(context).pop();

  void _finishSession(String message) {
    // TODO: هون رح نرسل نتيجة الجلسة (مقبول/غير مقبول) + مواضع الكلمات
    // الملوّنة كملاحظات تسميع للباك ايند عبر Dio بدل SnackBar المؤقت.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: RecitationTopBar(
          surahName: widget.range.surahName,
          fromPage: widget.range.fromPage,
          toPage: widget.range.toPage,
          studentName: widget.studentName,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            children: [
              _buildBasmalaPill(context),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 16,
                spacing: 6,
                textDirection: TextDirection.rtl,
                children: [
                  for (int i = 0; i < _words.length; i++)
                    HighlightableWord(
                      text: _words[i].text,
                      highlight: _words[i].highlight,
                      onChanged: (color) => _setHighlight(i, color),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RecitationActionBar(
        onAccepted: _handleAccepted,
        onRejected: _handleRejected,
        onCancelled: _handleCancelled,
      ),
    );
  }

  /// شارة "بسم الله الرحمن الرحيم" العلوية — نفس شكل التصميم المرجعي
  /// (كبسولة بلون خفيف من الثيم الحالي، بدون لون ثابت).
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
