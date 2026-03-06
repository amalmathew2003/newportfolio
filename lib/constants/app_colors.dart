import 'package:flutter/material.dart';

/// Centralized color tokens for the portfolio.
/// Prevents 50+ hardcoded color literals scattered across files.
class AppColors {
  AppColors._();

  // ─── Dark Theme Accent Colors ───
  static const neonGreen = Color(0xFF00FFA3);
  static const violet = Color(0xFF8B5CF6);
  static const pink = Color(0xFFFF006E);
  static const cyan = Color(0xFF00D4FF);
  static const amber = Color(0xFFFFC107);

  // ─── Dark Theme Backgrounds ───
  static const darkBg = Color(0xFF0A0A0F);
  static const darkSurface = Color(0xFF12121A);

  // ─── Light Theme Accent Colors ───
  static const bronze = Color(0xFF96805D);
  static const charcoal = Color(0xFF111111);
  static const blue = Color(0xFF3B82F6);
  static const lightPink = Color(0xFFEC4899);

  // ─── Light Theme Backgrounds ───
  static const linen = Color(0xFFF9F7F2);

  // ─── Social Colors ───
  static const linkedin = Color(0xFF0A66C2);

  // ─── Helpers ───

  /// Returns the primary accent for the current brightness.
  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? neonGreen : blue;
  }

  /// Returns the secondary accent for the current brightness.
  static Color secondaryAccent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? violet : bronze;
  }

  /// Returns the heading text color for the current brightness.
  static Color headingColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : charcoal;
  }

  /// Returns muted text color for the current brightness.
  static Color mutedText(BuildContext context, {double alpha = 0.5}) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }

  /// Returns a subtle border color for the current brightness.
  static Color subtleBorder(BuildContext context, {double alpha = 0.08}) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }
}
