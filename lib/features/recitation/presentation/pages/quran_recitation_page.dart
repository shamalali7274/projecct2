import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/quran_accent_colors.dart';
import '../../domain/entities/quran_word_entity.dart';
import '../../domain/entities/recitation_range_entity.dart';
import '../widgets/highlightable_word.dart';
import '../widgets/recitation_action_bar.dart';

/// صفحة "المصحف" الخاصة بجلسة التسميع.
///
/// بتستخدم نفس ألوان وخط باقي التطبيق (Theme.of(context)) — بدون ثيم
/// منفصل — حتى تضل بروح المشروع نفسها، وبتدعم فاتح/داكن تلقائياً
/// لأنها ما بتفرض أي لون ثابت.
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
    const text = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ '
        'الرَّحْمَٰنِ الرَّحِيمِ مَالِكِ يَوْمِ الدِّينِ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ '
        'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ';
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.studentName, style: textTheme.titleMedium?.copyWith(color: scheme.primary)),
            Text(
              '${widget.range.surahName} • صفحة ${widget.range.fromPage} - ${widget.range.toPage}',
              style: textTheme.labelSmall,
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 12,
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
        ),
      ),
      bottomNavigationBar: RecitationActionBar(
        onAccepted: _handleAccepted,
        onRejected: _handleRejected,
        onCancelled: _handleCancelled,
      ),
    );
  }
}
