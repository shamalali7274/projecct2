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

/// انتقال بأسلوب تيليجرام (Slide من اليمين لليسار مع خروج متزامن).
class TelegramPageRoute extends PageRouteBuilder {
  TelegramPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOut;

            final tweenIn = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            final tweenOut = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(1.0, 0.0),
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tweenIn),
              child: SlideTransition(
                position: secondaryAnimation.drive(tweenOut),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
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
    return Navigator.of(context).push<T>(SharedAxisPageRoute(page: page) as Route<T>);
  }

  static Future<T?> pushSharedAxisAndRemoveAll<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      SharedAxisPageRoute(page: page) as Route<T>,
      (route) => false,
    );
  }

  static Future<T?> pushTelegramStyle<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(TelegramPageRoute(page: page) as Route<T>);
  }
}
