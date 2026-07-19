import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// نقطة بناء الثيم الموحّدة - يوفّر ThemeData جاهز للوضعين الفاتح والداكن.
/// أي تعديل مستقبلي على الشكل العام (ظلال، حواف الأزرار...) يتم من هنا
/// فقط بدل تعديل كل واجهة على حدة.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppColors.light);
  static ThemeData get dark => _build(AppColors.dark);

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: AppTextStyles.textTheme(scheme),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        filled: false,
      ),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      dividerColor: scheme.surfaceContainerLow,
    );
  }
}
