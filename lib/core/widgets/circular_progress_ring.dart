import 'package:flutter/material.dart';

/// حلقة تقدّم دائرية بنسبة مئوية بالمنتصف — قابلة لإعادة الاستخدام
/// بأي مكان يحتاج عرض نسبة إنجاز بشكل دائري (بدل شريط أفقي فقط).
class CircularProgressRing extends StatelessWidget {
  const CircularProgressRing({
    super.key,
    required this.percent,
    this.size = 120,
    this.strokeWidth = 9,
    this.label = 'التقدم',
  });

  final int percent;
  final double size;
  final double strokeWidth;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              color: scheme.surfaceContainerHighest,
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: (percent / 100).clamp(0, 1),
              strokeWidth: strokeWidth,
              color: scheme.primary,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: textTheme.headlineSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
              ),
              Text(label, style: textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
