import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/cubit/theme_cubit.dart';

/// زر تبديل الثيم (فاتح/داكن) القابل لإعادة الاستخدام في أي شريط علوي
/// أو صفحة إعدادات. يقرأ الحالة الحالية من ThemeCubit ويبدّلها عند الضغط.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark ? 'التبديل للوضع الفاتح' : 'التبديل للوضع الداكن',
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(),
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: scheme.primary,
            size: 22,
          ),
        );
      },
    );
  }
}
