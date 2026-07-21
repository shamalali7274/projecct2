import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// زر دائري (أيقونة + تسمية تحته) قابل لإعادة الاستخدام بأي حجم/لون.
/// يُبنى مرة واحدة هون، وكل مكان يحتاجه (شريط إجراءات التسميع مثلاً)
/// بيمرّر له القياسات المطلوبة فقط بدل تكرار نفس الكود بحجم مختلف.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.size = 56,
    this.iconSize = 24,
    this.labelColor,
    this.glow = false,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color? labelColor;

  /// هالة ناعمة حول الزر لإبراز الإجراء الأساسي (مثل "مقبول")
  /// عن باقي الأزرار، بدل ما نبني ودجت منفصل خصيصاً لهاد الزر.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                boxShadow: glow
                    ? [
                        BoxShadow(
                          color: backgroundColor.withOpacity(0.45),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(icon, color: iconColor, size: iconSize),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: labelColor ?? scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
