import 'package:flutter/material.dart';

/// Premium Black & White editorial color system.
/// Dark Mode: Deep black surfaces, white accents.
/// Light Mode: Pure white surfaces, black accents.
class AppColors {
  AppColors._();

  // ─── Core Palette ───────────────────────────────────────────────────────────
  static const pureBlack    = Color(0xFF080808);
  static const richBlack    = Color(0xFF111111);
  static const charcoal     = Color(0xFF1A1A1A);
  static const darkGray     = Color(0xFF2A2A2A);
  static const midGray      = Color(0xFF555555);
  static const lightGray    = Color(0xFF888888);
  static const offWhite     = Color(0xFFF0F0F0);
  static const nearWhite    = Color(0xFFFAFAFA);
  static const pureWhite    = Color(0xFFFFFFFF);

  // ─── Semantic Surface ────────────────────────────────────────────────────────
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? pureBlack
        : nearWhite;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? richBlack
        : pureWhite;
  }

  static Color surfaceElevated(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? charcoal
        : offWhite;
  }

  // ─── Accent (inverted for high contrast) ─────────────────────────────────────
  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? pureWhite
        : pureBlack;
  }

  // ─── Text ────────────────────────────────────────────────────────────────────
  static Color headingColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? pureWhite
        : pureBlack;
  }

  static Color mutedText(BuildContext context, {double alpha = 0.45}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }

  // ─── Borders ─────────────────────────────────────────────────────────────────
  static Color subtleBorder(BuildContext context, {double alpha = 0.07}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }

  static Color mediumBorder(BuildContext context, {double alpha = 0.14}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }

  // ─── Glassmorphism Helper ─────────────────────────────────────────────────────
  static Color glass(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.03);
  }

  static Color glassHover(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
  }

  // ─── Glow Helper ─────────────────────────────────────────────────────────────
  static Color glow(BuildContext context, {double alpha = 0.12}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }

  // ─── Legacy Aliases (for backward compatibility) ─────────────────────────────
  static const primaryAmber = pureWhite;  // mapped to accent
  static const primaryRed   = pureWhite;  // mapped to accent
  static const deepBlack    = pureBlack;
  static const deepGrey     = charcoal;
  static const woodBrown    = pureBlack;
  static const creamWhite   = nearWhite;
  static const techWhite    = pureWhite;
}
