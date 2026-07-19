import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// يبني TextTheme موحّد لكل التطبيق:
/// - Amiri للعناوين الكبيرة (Headline) بروح تحريرية/تراثية
/// - Tajawal للنصوص والواجهة (Body/Label) لوضوح أفضل في RTL
class AppTextStyles {
  AppTextStyles._();

  static TextTheme textTheme(ColorScheme scheme) {
    final headline = GoogleFonts.amiriTextTheme();
    final body = GoogleFonts.tajawalTextTheme();

    return body.copyWith(
      displayLarge: headline.displayLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: headline.displayMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: headline.headlineLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: headline.headlineMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: headline.headlineSmall?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: body.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w800,
      ),
      titleMedium: body.titleMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: body.titleSmall?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: body.bodyLarge?.copyWith(color: scheme.onSurface),
      bodyMedium: body.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      bodySmall: body.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      labelLarge: body.labelLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: body.labelMedium?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: body.labelSmall?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
