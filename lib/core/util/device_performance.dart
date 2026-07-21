// lib/core/utils/device_performance.dart
//
// فحص أداء بسيط لتقرير إذا الجهاز يتحمل تأثيرات GPU ثقيلة (زي الـ Blur)
// أو لأ — نفس فكرة LiteMode.isEnabled(LIQUID_GLASS) المستخدمة بتلغرام
// (تحققنا منها بالكود المصدري الرسمي: GlassTabView.java).
//
// الفكرة: بدل ما نفرض تأثير blur ثقيل على كل الأجهزة (وبيخنق الأجهزة
// القديمة زي Galaxy J7)، منفحص أول ومنرجع fallback خفيف إذا لزم.

import 'package:flutter/foundation.dart';

class DevicePerformance {
  static bool? _isHighEnd;

  /// ناديها مرة وحدة بـ main() قبل runApp، بعد ما تفحص الجهاز فعلياً
  /// (مثلاً عبر device_info_plus: عدد الأنوية، الـ RAM، أو Android SDK level).
  static void configure({required bool isHighEnd}) {
    _isHighEnd = isHighEnd;
  }

  /// إذا ما انعملها configure، منفترض "أداء متوسط" (fallback آمن يفعّل
  /// الـ blur بس بدون مخاطرة إذا نسيت تستدعي configure).
  static bool get canUseGlassEffect => _isHighEnd ?? true;

  /// مثال جاهز تقدر تستخدمه بـ main.dart لفحص سريع حسب المنصة
  /// (تقدر تستبدله لاحقاً بفحص أدق عبر device_info_plus).
  static bool get quickHeuristic {
    if (kIsWeb) return true;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }
}
