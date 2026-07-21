import 'package:academic_concourse_for_girls/core/navigation/page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_dots_indicator.dart';
import '../widgets/onboarding_slides.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';
import '../../../auth/presentation/pages/sign_up_page.dart';

/// شاشة onboarding: 4 شرائح تعريفية تُعرض عند أول استخدام للتطبيق.

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignIn(BuildContext context) {
    Navigator.of(context).push(TelegramPageRoute(page: const SignInPage()));
  }

  void _goToSignUp(BuildContext context) {
    Navigator.of(context).push(TelegramPageRoute(page: const SignUpPage()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, int>(
      listener: (context, index) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) =>
                  context.read<OnboardingCubit>().goTo(index),
              children: [
                const WelcomeSlide(),
                const MemorizationTrackingSlide(),
                const SelfDevelopmentSlide(),
                CommunitySlide(
                  onSignIn: () => _goToSignIn(context),
                  onSignUp: () => _goToSignUp(context),
                ),
              ],
            ),
            Positioned(
              bottom:
                  AppSpacing.xxl +
                  AppSpacing.md, // رفعناها شوي لفوق (56 بدل 40)
              left: 0,
              right: 0,
              child: Center(
                child: BlocBuilder<OnboardingCubit, int>(
                  builder: (context, index) {
                    return OnboardingDotsIndicator(
                      count: OnboardingCubit.totalSlides,
                      currentIndex: index,
                      onDotTap: (i) => context.read<OnboardingCubit>().goTo(i),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
