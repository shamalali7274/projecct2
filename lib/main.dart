import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/navigation/auth_gate.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  runApp(const MusmiahApp());
}

/// نقطة انطلاق التطبيق.
///
/// TODO: عند إضافة ميزات جديدة تحتاج حالة عامة (مثل DashboardBloc)،
/// ضيفيها هون بنفس القائمة جنب ThemeCubit و AuthCubit.
class MusmiahApp extends StatelessWidget {
  const MusmiahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            title: 'لوحة المسمعة',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            // الوضع الآن يُتحكم به من داخل التطبيق عبر ThemeCubit
            // بدل الاعتماد فقط على إعدادات نظام التشغيل.
            themeMode: mode,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: child,
                  ),
                ),
              );
            },
            // AuthGate هو نقطة الدخول الآن (بدل DashboardPage مباشرة) —
            // هو اللي بيقرر تسجيل الدخول أو أي واجهة تُفتح حسب role.
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
