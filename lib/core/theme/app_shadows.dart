import 'package:flutter/material.dart';

/// Soft, subtle shadow presets. Kept low-opacity and diffuse to match
/// a premium, minimal aesthetic (never harsh drop shadows).
class AppShadows {
  AppShadows._();

  static List<BoxShadow> card({bool dark = false}) => [
        BoxShadow(
          color: (dark ? Colors.black : const Color(0xFF10192B))
              .withValues(alpha: dark ? 0.35 : 0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> subtle({bool dark = false}) => [
        BoxShadow(
          color: (dark ? Colors.black : const Color(0xFF10192B))
              .withValues(alpha: dark ? 0.25 : 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> floating({bool dark = false}) => [
        BoxShadow(
          color: (dark ? Colors.black : const Color(0xFF10192B))
              .withValues(alpha: dark ? 0.45 : 0.12),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];
}
