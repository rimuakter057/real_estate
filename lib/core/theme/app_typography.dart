import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography using Plus Jakarta Sans for a clean, modern,
/// commercial-app feel (a refined alternative to generic system fonts).
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color primary, Color secondary) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(
              fontWeight: FontWeight.w700, color: primary, fontSize: 34, height: 1.2),
          displayMedium: base.displayMedium?.copyWith(
              fontWeight: FontWeight.w700, color: primary, fontSize: 28, height: 1.2),
          headlineLarge: base.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700, color: primary, fontSize: 24, height: 1.25),
          headlineMedium: base.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700, color: primary, fontSize: 20, height: 1.25),
          headlineSmall: base.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600, color: primary, fontSize: 18, height: 1.3),
          titleLarge: base.titleLarge?.copyWith(
              fontWeight: FontWeight.w600, color: primary, fontSize: 17, height: 1.3),
          titleMedium: base.titleMedium?.copyWith(
              fontWeight: FontWeight.w600, color: primary, fontSize: 15, height: 1.3),
          titleSmall: base.titleSmall?.copyWith(
              fontWeight: FontWeight.w600, color: primary, fontSize: 13, height: 1.3),
          bodyLarge: base.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500, color: primary, fontSize: 16, height: 1.5),
          bodyMedium: base.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400, color: secondary, fontSize: 14, height: 1.5),
          bodySmall: base.bodySmall?.copyWith(
              fontWeight: FontWeight.w400, color: secondary, fontSize: 12, height: 1.4),
          labelLarge: base.labelLarge?.copyWith(
              fontWeight: FontWeight.w600, color: primary, fontSize: 14, height: 1.2),
          labelMedium: base.labelMedium?.copyWith(
              fontWeight: FontWeight.w600, color: secondary, fontSize: 12, height: 1.2),
          labelSmall: base.labelSmall?.copyWith(
              fontWeight: FontWeight.w500, color: secondary, fontSize: 11, height: 1.2),
        )
        .apply(fontFamily: GoogleFonts.plusJakartaSans().fontFamily);
  }

  static TextTheme get light => textTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight);
  static TextTheme get dark => textTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark);
}
