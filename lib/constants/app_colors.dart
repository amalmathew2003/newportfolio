import 'package:flutter/material.dart';

/// Centralized color tokens for the luxury portfolio.
class AppColors {
  AppColors._();

  // ─── Luxury Theme Colors (Ducati/Bugatti Inspired) ───
  static const primaryRed = Color(0xFFE31837);
  static const charcoal = Color(0xFF111111);
  static const deepGrey = Color(0xFF1A1A1A);
  static const techWhite = Color(0xFFFBFBFB);
  static const woodBrown = Color(0xFF745131); // Premium Oak
  static const creamWhite = Color(0xFFF9F7F5); // Warm luxury white

  // ─── Dark Theme Backgrounds ───
  static const darkBg = charcoal;
  static const darkSurface = deepGrey;

  // ─── Helpers ───
  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? primaryRed : woodBrown;
  }

  static Color headingColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : woodBrown;
  }

  static Color mutedText(BuildContext context, {double alpha = 0.5}) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }

  static Color subtleBorder(BuildContext context, {double alpha = 0.08}) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }
}
