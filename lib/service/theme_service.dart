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
      scaffoldBackgroundColor: AppColors.pureBlack,
      primaryColor: AppColors.pureWhite,
      dividerColor: Colors.white.withValues(alpha: 0.07),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.pureWhite,
        secondary: AppColors.offWhite,
        surface: AppColors.richBlack,
        outline: AppColors.charcoal,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.nearWhite,
      primaryColor: AppColors.pureBlack,
      dividerColor: Colors.black.withValues(alpha: 0.07),
      colorScheme: const ColorScheme.light(
        primary: AppColors.pureBlack,
        secondary: AppColors.charcoal,
        surface: AppColors.pureWhite,
        outline: AppColors.offWhite,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.libreBodoni(
          color: AppColors.pureBlack,
          fontWeight: FontWeight.w900,
        ),
        displayMedium: GoogleFonts.libreBodoni(
          color: AppColors.pureBlack,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
