import 'package:flutter/material.dart';

/// مكوّن قابل لإعادة الاستخدام يعرض نص HTML "بسيط" (مخرجات مرحلة
/// تحضير كتاب التبيان بالـ OCR: نص عادي + <span style="color:XXX">...
/// </span> لتمييز الكلمات المتشابهة) كنص Flutter ملوّن فعلياً، بدون
/// حزمة HTML كاملة — الشكل المستخدم بالباك ايند محصور بوسم <span>
/// واحد بخاصية color فقط، فبنينا Parser صغير مخصص لهاد الشكل تحديداً
/// بدل تحميل مكتبة كاملة لأجل حالة واحدة.
///
/// مبني مرة واحدة ويُستدعى من أي مكان بالتطبيق يحتاج يعرض نص مشابه
/// (حالياً: MawdiCard)، فقط بتمرير الـ html والستايل الأساسي —
/// بلا تكرار لمنطق الـ Parsing بكل صفحة.
class ColoredHtmlText extends StatelessWidget {
  const ColoredHtmlText({
    super.key,
    required this.html,
    this.baseStyle,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.rtl,
  });

  /// النص الخام القادم من الباك ايند (mawdi.html_text عبر mawadi_by_page).
  final String html;

  /// ستايل النص الافتراضي (للأجزاء غير الملوّنة). ألوان الـ <span> نفسها
  /// تُقرأ من داخل الـ HTML وتُطبَّق فوق هاد الستايل.
  final TextStyle? baseStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;

  static final RegExp _spanPattern = RegExp(
    r'<span[^>]*style="[^"]*color:\s*([#\w]+)[^"]*"[^>]*>(.*?)</span>',
    caseSensitive: false,
    dotAll: true,
  );

  @override
  Widget build(BuildContext context) {
    final defaultStyle = baseStyle ?? Theme.of(context).textTheme.bodyLarge;
    final spans = _parse(html, defaultStyle);

    return RichText(
      textAlign: textAlign,
      textDirection: textDirection,
      text: TextSpan(style: defaultStyle, children: spans),
    );
  }

  /// يفكّك الـ HTML لسلسلة TextSpan: أي جزء عادي بالستايل الافتراضي،
  /// وأي جزء داخل <span style="color:..."> بلونه الخاص المُستخرج نصياً.
  List<InlineSpan> _parse(String source, TextStyle? defaultStyle) {
    final spans = <InlineSpan>[];
    var lastEnd = 0;

    for (final match in _spanPattern.allMatches(source)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: _stripTags(source.substring(lastEnd, match.start))));
      }
      final colorText = match.group(1) ?? '';
      final innerText = _stripTags(match.group(2) ?? '');
      spans.add(TextSpan(
        text: innerText,
        style: TextStyle(color: _resolveColor(colorText)),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < source.length) {
      spans.add(TextSpan(text: _stripTags(source.substring(lastEnd))));
    }

    return spans;
  }

  String _stripTags(String text) => text.replaceAll(RegExp(r'<[^>]+>'), '');

  Color _resolveColor(String colorText) {
    final normalized = colorText.trim().toLowerCase();
    if (normalized.startsWith('#')) {
      var hex = normalized.substring(1);
      if (hex.length == 6) hex = 'ff$hex';
      return Color(int.parse(hex, radix: 16));
    }
    switch (normalized) {
      case 'red':
        return const Color(0xFFD32F2F);
      case 'green':
        return const Color(0xFF2E7D32);
      case 'blue':
        return const Color(0xFF1565C0);
      default:
        return const Color(0xFFD32F2F); // افتراضي: القيمة الوحيدة المستخدمة حالياً بالباك ايند هي red
    }
  }
}
