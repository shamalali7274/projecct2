import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/domain/entities/user_role.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/student_home/presentation/pages/student_home_placeholder_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

/// نقطة القرار الوحيدة لأي واجهة تُفتح بالتطبيق:
/// - أثناء التحقق من الجلسة → شاشة تحميل.
/// - ما في جلسة / فشل → OnboardingPage (اللي منها بتوصل لـ
///   SignInPage/SignUpPage).
/// - جلسة ناجحة بـ role = supervisor → DashboardPage.
/// - جلسة ناجحة بـ role = student → واجهة الطالبة.
///
/// نفس منطق التوجيه القديم بالضبط — الفرق الوحيد إن البديل عن
/// "ما في جلسة" صار OnboardingPage بدل LoginPage القديمة.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const _SplashLoader();
        }
        if (state is AuthAuthenticated) {
          return state.role == UserRole.supervisor
              ? const DashboardPage()
              : const StudentHomePage();
        }
        // AuthUnauthenticated أو AuthError
        return const OnboardingPage();
      },
    );
  }
}

class _SplashLoader extends StatelessWidget {
  const _SplashLoader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(child: CircularProgressIndicator(color: scheme.primary)),
    );
  }
}
