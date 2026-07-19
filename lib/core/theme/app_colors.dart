import 'package:flutter/material.dart';

/// يحتوي هذا الملف على جميع ألوان النظام (الوضع الفاتح والداكن).
/// الألوان مبنية حسب أدوار Material 3 (ColorScheme Roles) بحيث تُستخدم
/// من مكان واحد فقط في كل الواجهات عبر Theme.of(context).colorScheme
/// بدل كتابة أكواد الألوان (Hex) بشكل متكرر داخل الودجتس.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // الوضع الفاتح (Light Theme) - مطابق تماماً لملف التصميم DESIGN.md
  // ---------------------------------------------------------------------
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF00542A),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF0A6F3A),
    onPrimaryContainer: Color(0xFF96EFAC),
    secondary: Color(0xFF6B5A61),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF1DAE2),
    onSecondaryContainer: Color(0xFF6F5E65),
    tertiary: Color(0xFF514738),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF6A5F4F),
    onTertiaryContainer: Color(0xFFE9DAC6),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFFBF9F5),
    onSurface: Color(0xFF1B1C1A),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF5F3EF),
    surfaceContainer: Color(0xFFEFEEEA),
    surfaceContainerHigh: Color(0xFFEAE8E4),
    surfaceContainerHighest: Color(0xFFE4E2DE),
    onSurfaceVariant: Color(0xFF3F4940),
    outline: Color(0xFF6F7A6F),
    outlineVariant: Color(0xFFBEC9BD),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF30312E),
    onInverseSurface: Color(0xFFF2F0ED),
    inversePrimary: Color(0xFF81D999),
    surfaceTint: Color(0xFF056D38),
    primaryFixed: Color(0xFF9CF6B3),
    primaryFixedDim: Color(0xFF81D999),
    onPrimaryFixed: Color(0xFF00210D),
    onPrimaryFixedVariant: Color(0xFF005228),
    secondaryFixed: Color(0xFFF3DDE5),
    secondaryFixedDim: Color(0xFFD7C1C9),
    onSecondaryFixed: Color(0xFF24181E),
    onSecondaryFixedVariant: Color(0xFF524349),
    tertiaryFixed: Color(0xFFF0E0CC),
    tertiaryFixedDim: Color(0xFFD3C4B1),
    onTertiaryFixed: Color(0xFF221A0E),
    onTertiaryFixedVariant: Color(0xFF4F4537),
    surfaceDim: Color(0xFFDBDAD6),
    surfaceBright: Color(0xFFFBF9F5),
  );

  // ---------------------------------------------------------------------
  // الوضع الداكن (Dark Theme)
  // ملف التصميم الأصلي لم يحدد قيماً داكنة صريحة، لذلك تم اشتقاقها هنا
  // باتباع منهجية Material 3 القياسية (قابلة للتعديل من هذا الملف فقط).
  // ---------------------------------------------------------------------
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF81D999),
    onPrimary: Color(0xFF00391C),
    primaryContainer: Color(0xFF005228),
    onPrimaryContainer: Color(0xFF9CF6B3),
    secondary: Color(0xFFD7C1C9),
    onSecondary: Color(0xFF3B2D33),
    secondaryContainer: Color(0xFF524349),
    onSecondaryContainer: Color(0xFFF3DDE5),
    tertiary: Color(0xFFD3C4B1),
    onTertiary: Color(0xFF362C1E),
    tertiaryContainer: Color(0xFF4F4537),
    onTertiaryContainer: Color(0xFFF0E0CC),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF131512),
    onSurface: Color(0xFFE3E3DE),
    surfaceContainerLowest: Color(0xFF0D0F0D),
    surfaceContainerLow: Color(0xFF1B1C1A),
    surfaceContainer: Color(0xFF1F211E),
    surfaceContainerHigh: Color(0xFF2A2B28),
    surfaceContainerHighest: Color(0xFF353632),
    onSurfaceVariant: Color(0xFFBEC9BD),
    outline: Color(0xFF899287),
    outlineVariant: Color(0xFF3F4940),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE3E3DE),
    onInverseSurface: Color(0xFF30312E),
    inversePrimary: Color(0xFF00542A),
    surfaceTint: Color(0xFF81D999),
    primaryFixed: Color(0xFF9CF6B3),
    primaryFixedDim: Color(0xFF81D999),
    onPrimaryFixed: Color(0xFF00210D),
    onPrimaryFixedVariant: Color(0xFF005228),
    secondaryFixed: Color(0xFFF3DDE5),
    secondaryFixedDim: Color(0xFFD7C1C9),
    onSecondaryFixed: Color(0xFF24181E),
    onSecondaryFixedVariant: Color(0xFF524349),
    tertiaryFixed: Color(0xFFF0E0CC),
    tertiaryFixedDim: Color(0xFFD3C4B1),
    onTertiaryFixed: Color(0xFF221A0E),
    onTertiaryFixedVariant: Color(0xFF4F4537),
    surfaceDim: Color(0xFF131512),
    surfaceBright: Color(0xFF393A36),
  );
}
