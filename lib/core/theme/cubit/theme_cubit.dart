import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit بسيط يتحكم بوضع الثيم (فاتح/داكن) من داخل التطبيق نفسه،
/// بدل الاعتماد فقط على إعدادات نظام التشغيل (ThemeMode.system).
///
/// أي Widget بالتطبيق فيه إمكانية يقرأ الوضع الحالي عبر
/// `context.watch<ThemeCubit>().state` أو يبدّله عبر
/// `context.read<ThemeCubit>().toggleTheme()`.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  void setTheme(ThemeMode mode) => emit(mode);
}
