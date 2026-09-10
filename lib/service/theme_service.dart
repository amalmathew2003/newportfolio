import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.ink,
      primaryColor: AppColors.mist,
      cardColor: AppColors.surface,
      dividerColor: AppColors.lineDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mist,
        secondary: AppColors.cyan,
        surface: AppColors.surface,
        outline: AppColors.lineDark,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.mist,
        displayColor: AppColors.mist,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      primaryColor: AppColors.charcoal,
      cardColor: AppColors.paperSurface,
      dividerColor: AppColors.lineLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.charcoal,
        secondary: AppColors.pink,
        surface: AppColors.paperSurface,
        outline: AppColors.lineLight,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.charcoal,
        displayColor: AppColors.charcoal,
      ),
    );
  }
}

