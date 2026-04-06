import 'package:flutter/material.dart';

/// Centralized color tokens for the portfolio.
/// Dark Mode: Amber & Charcoal (New)
/// Light Mode: White & Wood (Original)
class AppColors {
  AppColors._();

  // ─── Reference Palette (Amber & Black - DARK ONLY) ───
  static const primaryAmber = Color(0xFFF39C12); 
  static const deepBlack = Color(0xFF0F0F0F);    
  static const charcoal = Color(0xFF171717);    
  
  // ─── Reference Palette (White & Wood - LIGHT ONLY) ───
  static const woodBrown = Color(0xFF745131); 
  static const creamWhite = Color(0xFFF9F7F5); 
  static const techWhite = Color(0xFFFFFFFF);

  // ─── Logic Adapters ───
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
      ? deepBlack 
      : creamWhite;
  }

  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
      ? primaryAmber 
      : woodBrown;
  }

  static Color headingColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
      ? Colors.white 
      : woodBrown;
  }

  // ─── Legacy Aliases ───
  static const primaryRed = primaryAmber; // Dark Mode Red is now Amber
  static const deepGrey = charcoal;

  static Color mutedText(BuildContext context, {double alpha = 0.5}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }

  static Color subtleBorder(BuildContext context, {double alpha = 0.08}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha);
  }
}
