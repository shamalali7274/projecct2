import 'package:flutter/material.dart';
import '../../../../core/navigation/page_transitions.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';
import '../../../auth/presentation/pages/sign_up_page.dart';
import '../widgets/onboarding_slides.dart';

/// شاشة تُعرض فور تسجيل الخروج فقط: نفس شريحة "لستِ وحدكِ في الرحلة"
/// (CommunitySlide) الأخيرة من OnboardingPage، بس من دون الـ PageView
/// ولا نقاط التنقل ولا باقي شرائح الترحيب (Welcome / Tracking /
/// SelfDevelopment). الهدف إنو المستخدمة توصل مباشرة لأزرار "تسجيل
/// الدخول" و"إنشاء حساب" بدون ما تمر على شرائح تعريفية شافتها قبل هيك.
class PostLogoutWelcomePage extends StatelessWidget {
  const PostLogoutWelcomePage({super.key});

  void _goToSignIn(BuildContext context) {
    Navigator.of(context).push(TelegramPageRoute(page: const SignInPage()));
  }

  void _goToSignUp(BuildContext context) {
    Navigator.of(context).push(TelegramPageRoute(page: const SignUpPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommunitySlide(
        onSignIn: () => _goToSignIn(context),
        onSignUp: () => _goToSignUp(context),
      ),
    );
  }
}
