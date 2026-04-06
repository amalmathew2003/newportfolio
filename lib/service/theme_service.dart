import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.charcoal,
      primaryColor: AppColors.primaryRed,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryRed,
        secondary: Color(0xFFFFFFFF),
        surface: AppColors.deepGrey,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFBFBFB), // Clinical off-white
      primaryColor: AppColors.charcoal,
      colorScheme: const ColorScheme.light(
        primary: AppColors.charcoal,
        secondary: AppColors.primaryRed, // Use red as accent in light mode too
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.libreBodoni(
          color: AppColors.charcoal,
          fontWeight: FontWeight.w900,
        ),
        displayMedium: GoogleFonts.libreBodoni(
          color: AppColors.charcoal,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
