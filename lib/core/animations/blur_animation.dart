import 'package:flutter/material.dart';

class AnimationManager {
  final AnimationController controller;

  late Animation<double> fade; // شفافية عامة
  late Animation<double> blur; // ضبابية الخلفية
  late Animation<double> scale; // لتكبير وتصغير العناصر
  late List<Animation<Offset>> steppers; // حركة Stepper لكل عنصر

  AnimationManager(this.controller) {
    // الشفافية العامة Fade
    fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    // Blur → Clear
    blur = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Scale + Fade
    scale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Stepper animation لكل عنصر في الفورم
    steppers = List.generate(8, (index) {
      double start = index * 0.12; // كل عنصر يبدأ بعد الثاني
      double end = start + 0.55;

      return Tween<Offset>(
        begin: const Offset(1.0, 0.0), // من اليمين → لليسار
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });
  }
}
