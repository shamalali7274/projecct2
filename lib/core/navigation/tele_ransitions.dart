import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// انتقال Shared Axis (أفقي) — يُستخدم للتنقل العادي بين الصفحات الرئيسية.
class SharedAxisPageRoute extends PageRouteBuilder {
  SharedAxisPageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
      );

  final Widget page;
}

// ============================================================
// المنحنى الحقيقي المستخدم بتلغرام: android.view.animation
// .DecelerateInterpolator(1.5f)
//
// الصيغة الرسمية لهاد الـ interpolator بأندرويد:
//   output = 1 - (1 - input) ^ (2 * factor)
// وبما إنه factor = 1.5 هون (مثبتة بكود ActionBarLayout.java
// بالضبط: "new DecelerateInterpolator(1.5f)")، الأس بيصير 3.0.
// ============================================================
class _TelegramDecelerateCurve extends Curve {
  const _TelegramDecelerateCurve();

  @override
  double transformInternal(double t) {
    return 1.0 - math.pow(1.0 - t, 3.0).toDouble();
  }
}

/// انتقال بأسلوب تيليجرام الحقيقي (مبني على تحليل الكود المصدري الرسمي
/// لدالة startLayoutAnimation بملف ActionBarLayout.java):
///
///   - المدة: 150ms بالضبط (مش 300+ متل انتقالات تانية شائعة)
///   - المنحنى: DecelerateInterpolator(1.5f) → أس 3.0 (مو easeInOut عام)
///   - الحركة: انزلاق 48dp فقط (مو الشاشة كاملة!) + fade بنفس الوقت
///   - ظل ناعم (layerShadowDrawable الأصلي) عالحافة الخلفية للصفحة
///     الجديدة، بيتحرك معها بنفس اللحظة ويوصل لأقصى عتامته تقريباً
///     بعد أول 20dp من الحركة (نفس صيغة الكود: alpha = 255*widthOffset/20dp)
///   - الصفحة تحت (يلي بتنكشف عند الرجوع، أو الموجودة أصلاً عند الفتح)
///     ثابتة بالكامل بلا أي أنيميشن — هيك بالضبط بيتصرف تلغرام،
///     ولهيك secondaryAnimation ما منستخدمه إطلاقاً هون.
///     (فيه كمان scrim أسود خفيف جداً عالصفحة تحت بالكود الأصلي، بس
///     حسابياً أقل من 6% شفافية بسبب قصر مسافة الـ 48dp، فأهملناه
///     لأنه غير محسوس عملياً).
class TelegramPageRoute extends PageRouteBuilder {
  TelegramPageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = _TelegramDecelerateCurve();
          final curved = CurvedAnimation(parent: animation, curve: curve);

          // 48dp ≈ 48 لوجيكال بيكسل بفلاتر (نفس وحدة القياس تقريباً).
          // ملاحظة: هاد offset ثابت بالبيكسل، مش نسبة من عرض الشاشة —
          // هاد بالضبط سبب إحساس الخفة (تلغرام ما بيسحب الشاشة كاملة).
          const slideDistance = 48.0;
          const shadowWidth = 20.0; // نفس عرض layer_shadow.webp تقريباً

          return AnimatedBuilder(
            animation: curved,
            child: child,
            builder: (context, child) {
              final t = curved.value.clamp(0.0, 1.0);
              final dx = slideDistance * (1.0 - t);

              // widthOffset بالكود الأصلي = المسافة المقطوعة فعلياً.
              // alpha بيوصل لأقصاه (1.0) لما widthOffset يوصل 20dp.
              final widthOffset = slideDistance * t;
              final shadowAlpha = (widthOffset / shadowWidth).clamp(0.0, 1.0);

              return Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(dx, 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      child!,
                      // الظل: مباشرة على الحافة الخلفية (يسار) للصفحة
                      // الجديدة، متحرك معها بنفس اللحظة تماماً.
                      Positioned(
                        left: -shadowWidth,
                        top: 0,
                        bottom: 0,
                        width: shadowWidth,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: shadowAlpha,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0x00000000),
                                    Color(0x33000000), // ~20% أسود عند الحافة
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        transitionDuration: const Duration(milliseconds: 150),
        reverseTransitionDuration: const Duration(milliseconds: 150),
      );

  final Widget page;
}

/// دوال مساعدة جاهزة للتنقل بدل تكرار Navigator.push بكل مكان.
///
/// ملاحظة: "إزالة كل الصفحات السابقة" هو سلوك تنقّل (كيف تُستدعى الصفحة)
/// وليس نوع انتقال مختلف، لذلك صار دالة تستخدم pushAndRemoveUntil
/// بدل صنف PageRoute مكرر بلا أي فرق فعلي (متل ما كان بالملف الأصلي).
class AppNavigator {
  AppNavigator._();

  static Future<T?> pushSharedAxis<T>(BuildContext context, Widget page) {
    return Navigator.of(
      context,
    ).push<T>(SharedAxisPageRoute(page: page) as Route<T>);
  }

  static Future<T?> pushSharedAxisAndRemoveAll<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      SharedAxisPageRoute(page: page) as Route<T>,
      (route) => false,
    );
  }

  static Future<T?> pushTelegramStyle<T>(BuildContext context, Widget page) {
    return Navigator.of(
      context,
    ).push<T>(TelegramPageRoute(page: page) as Route<T>);
  }
}
