// telegram_shake.dart
//
// نفس تأثير "shakeViewSpring" الحقيقي من AndroidUtilities.java —
// المستخدم بصفحة تسجيل الدخول تبع تلغرام (كود التحقق، رقم الهاتف...)
// لما تدخل قيمة غلط أو فاضية وتحاول تكمّل.
//
// القيم الحرفية من الكود الأصلي:
//   - SpringForce stiffness = 600f
//   - dampingRatio = 0.5 (القيمة الافتراضية لـ SpringForce بأندرويد لما
//     ما تُحدَّد صراحة — DAMPING_RATIO_MEDIUM_BOUNCY)
//   - startVelocity = -shiftDp * 100 (shiftDp الافتراضي = 10dp)
//   - الهدف النهائي: يرجع لمكانه الأصلي (translationX = 0)

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class TelegramShake {
  TelegramShake._();

  /// يشغّل هزّة أفقية على أي Widget مربوط بـ [controller].
  /// [shiftDp] هو نفس معامل shiftDp بالكود الأصلي (الافتراضي 10).
  static void shake(
    AnimationController controller, {
    double shiftDp = 10,
    VoidCallback? onEnd,
  }) {
    const stiffness = 600.0;
    const dampingRatio = 0.5; // نفس default الأصلي بالحرف

    final simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1,
        stiffness: stiffness,
        ratio: dampingRatio,
      ),
      0, // البداية: بدون إزاحة
      0, // الهدف: يرجع لنفس المكان (0) — الحركة كلها بالسرعة الابتدائية
      -shiftDp * 100, // نفس startVelocity بالضبط من الكود الأصلي
    );

    controller.animateWith(simulation).whenComplete(() {
      onEnd?.call();
    });
  }
}

/// Widget جاهز يلف أي حقل (TextField مثلاً) ويعرّض دالة shake() تقدر
/// تناديها من برا (مثلاً لما تكتشف إنه الحقل فاضي عند الضغط على "تسجيل دخول").
class ShakeableField extends StatefulWidget {
  const ShakeableField({super.key, required this.child});
  final Widget child;

  @override
  State<ShakeableField> createState() => ShakeableFieldState();
}

class ShakeableFieldState extends State<ShakeableField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dx = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() => _dx = _controller.value));
  }

  /// نادي هاي الدالة لما تكتشف إنه الحقل فاضي أو القيمة غلط.
  void shake({double shiftDp = 10}) {
    TelegramShake.shake(_controller, shiftDp: shiftDp);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: Offset(_dx, 0), child: widget.child);
  }
}

// ============================================================
// مثال استخدام حقيقي — بالضبط سيناريو "ما عبيت الحقل وضغطت تسجيل دخول":
//
// final _emailFieldKey = GlobalKey<ShakeableFieldState>();
//
// ShakeableField(
//   key: _emailFieldKey,
//   child: AppTextField(label: 'البريد الإلكتروني', controller: _emailController),
// )
//
// // عند الضغط على زر "تسجيل دخول":
// void _onLoginTap() {
//   if (_emailController.text.trim().isEmpty) {
//     _emailFieldKey.currentState?.shake();
//     return;
//   }
//   // ... متابعة تسجيل الدخول
// }
// ============================================================
