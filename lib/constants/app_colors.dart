import 'package:flutter/material.dart';

/// Inspector Mode Design System Tokens
/// Flutter DevTools Inspector Aesthetic
class AppColors {
  AppColors._();

  // ─── Design Tokens ──────────────────────────────────────────────────────────
  static const ink          = Color(0xFF0B0E14); // Dark background
  static const surface      = Color(0xFF10141C); // Dark elevated surface
  static const paper        = Color(0xFFF4F4F2); // Light mode background
  static const paperSurface = Color(0xFFFFFFFF); // Light mode elevated surface
  static const mist         = Color(0xFFE8E9ED); // Primary text on dark
  static const charcoal     = Color(0xFF14161B); // Primary text on light
  static const dim          = Color(0xFF7A8091); // Secondary text (both modes)
  static const lineDark     = Color(0x29E8E9ED); // hairline border dark (0.16)
  static const lineLight    = Color(0x2414161B); // hairline border light (0.14)
  static const pink         = Color(0xFFFF3D81); // Signal accent 1 (padding guide)
  static const cyan         = Color(0xFF00E5C7); // Signal accent 2 (content guide)

  // ─── Context-Aware Surface Helpers ──────────────────────────────────────────
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? ink : paper;
  }

  static Color surfaceCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? surface : paperSurface;
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? mist : charcoal;
  }

  static Color secondaryText(BuildContext context) {
    return dim;
  }

  static Color line(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? lineDark : lineLight;
  }

  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? mist : charcoal;
  }

  // Legacy mappings for backward compatibility
  static Color headingColor(BuildContext context) => primaryText(context);
  static Color mutedText(BuildContext context, {double alpha = 0.5}) => dim;
  static Color subtleBorder(BuildContext context, {double alpha = 0.16}) => line(context);
  static Color mediumBorder(BuildContext context, {double alpha = 0.14}) => line(context);
  static Color glass(BuildContext context) => surfaceCard(context);
  static Color glassHover(BuildContext context) => line(context);
  static const primaryRed = pink;
  static const pureBlack = ink;
  static const richBlack = surface;
  static const pureWhite = paperSurface;
}


