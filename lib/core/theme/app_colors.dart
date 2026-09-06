import 'package:flutter/material.dart';

/// Centralized color palette for the app. One sophisticated accent
/// color (deep emerald) is used throughout, paired with a dark navy
/// ink color for text and an off-white surface for backgrounds.
class AppColors {
  AppColors._();

  // Brand
  static const Color accent = Color(0xFF0F6E5B); // deep emerald
  static const Color accentDark = Color(0xFF0B5747);
  static const Color accentLight = Color(0xFFE4F3EF);

  // Navy ink
  static const Color navy = Color(0xFF10192B);
  static const Color navySoft = Color(0xFF3A4356);

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFFAF9F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF3F2EE);
  static const Color lightBorder = Color(0xFFE7E5DE);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF0B0F17);
  static const Color darkSurface = Color(0xFF141B26);
  static const Color darkSurfaceAlt = Color(0xFF1B2330);
  static const Color darkBorder = Color(0xFF283041);

  // Semantic
  static const Color success = Color(0xFF1E9E5A);
  static const Color warning = Color(0xFFC98A1B);
  static const Color error = Color(0xFFD1453D);
  static const Color info = Color(0xFF2F6FED);

  // Text
  static const Color textPrimaryLight = Color(0xFF10192B);
  static const Color textSecondaryLight = Color(0xFF636B7A);
  static const Color textPrimaryDark = Color(0xFFF3F5F8);
  static const Color textSecondaryDark = Color(0xFF9AA3B2);

  // Status badges
  static const Color forSale = Color(0xFF0F6E5B);
  static const Color forRent = Color(0xFF2F6FED);
  static const Color sold = Color(0xFF8A8F98);

  // Neutral scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF2F2F0);
  static const Color grey200 = Color(0xFFE6E5E1);
  static const Color grey300 = Color(0xFFD3D2CC);
  static const Color grey400 = Color(0xFFA7A69F);
  static const Color grey500 = Color(0xFF7D7C76);
  static const Color grey600 = Color(0xFF5B5A55);

  static const Color goldStar = Color(0xFFE3A421);
}
