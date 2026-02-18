import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      scaffoldBackgroundColor: const Color(0xFF0A0A0F),
      primaryColor: const Color(0xFF00FFA3),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFA3),
        secondary: Color(0xFF8B5CF6),
        surface: Color(0xFF12121A),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF1F5F9), // Soft Slate
      primaryColor: const Color(0xFF3B82F6),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3B82F6),
        secondary: Color(0xFFEC4899),
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    );
  }
}
