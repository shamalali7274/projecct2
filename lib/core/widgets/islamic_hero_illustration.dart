import 'package:flutter/material.dart';

/// رسمة ترحيبية أصلية (أفق مآذن وقباب + هلال) بنفس ألوان هوية
/// التطبيق — رسم حقيقي بالكود (CustomPainter) بدل صورة خارجية،
/// حتى تنسجم تلقائياً مع الوضع الفاتح/الداكن، وما في أي مشكلة
/// ترخيص لأنها رسمة أصلية بالكامل.
class IslamicHeroIllustration extends StatelessWidget {
  const IslamicHeroIllustration({super.key, this.height = 170, this.borderRadius = 32});

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: CustomPaint(
          painter: _MosqueSkylinePainter(
            skyTop: scheme.secondaryContainer.withOpacity(0.55),
            skyBottom: scheme.surfaceContainerLowest,
            silhouette: scheme.primary,
          ),
        ),
      ),
    );
  }
}

class _MosqueSkylinePainter extends CustomPainter {
  _MosqueSkylinePainter({
    required this.skyTop,
    required this.skyBottom,
    required this.silhouette,
  });

  final Color skyTop;
  final Color skyBottom;
  final Color silhouette;

  static const Color _gold = Color(0xFFC5A059);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // خلفية سماء متدرجة ناعمة
    final skyRect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [skyTop, skyBottom],
        ).createShader(skyRect),
    );

    // الهلال الذهبي
    final crescentCenter = Offset(w * 0.8, h * 0.24);
    canvas.drawCircle(crescentCenter, 13, Paint()..color = _gold.withOpacity(0.9));
    canvas.drawCircle(crescentCenter.translate(6, -3), 11, Paint()..color = skyTop);

    // نجيمات صغيرة متناثرة
    final starPaint = Paint()..color = _gold.withOpacity(0.5);
    canvas.drawCircle(Offset(w * 0.15, h * 0.18), 2, starPaint);
    canvas.drawCircle(Offset(w * 0.55, h * 0.12), 1.5, starPaint);
    canvas.drawCircle(Offset(w * 0.35, h * 0.28), 1.5, starPaint);

    // أفق قباب ومآذن بسيط (سيلويت)
    final path = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.64)
      ..quadraticBezierTo(w * 0.07, h * 0.5, w * 0.14, h * 0.64)
      ..lineTo(w * 0.19, h * 0.64)
      ..lineTo(w * 0.19, h * 0.42)
      ..lineTo(w * 0.215, h * 0.42)
      ..lineTo(w * 0.215, h * 0.64)
      ..lineTo(w * 0.34, h * 0.64)
      ..cubicTo(w * 0.34, h * 0.34, w * 0.60, h * 0.34, w * 0.60, h * 0.64)
      ..lineTo(w * 0.75, h * 0.64)
      ..lineTo(w * 0.75, h * 0.42)
      ..lineTo(w * 0.775, h * 0.42)
      ..lineTo(w * 0.775, h * 0.64)
      ..quadraticBezierTo(w * 0.9, h * 0.5, w, h * 0.64)
      ..lineTo(w, h)
      ..close();

    canvas.drawPath(path, Paint()..color = silhouette.withOpacity(0.9));
  }

  @override
  bool shouldRepaint(covariant _MosqueSkylinePainter oldDelegate) {
    return oldDelegate.skyTop != skyTop ||
        oldDelegate.skyBottom != skyBottom ||
        oldDelegate.silhouette != silhouette;
  }
}
