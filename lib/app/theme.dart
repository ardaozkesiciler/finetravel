import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryBlue = Color(0xFF2F80ED);
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color cardDark = Color(0xFF161B22);
  static const Color textGray = Color(0xFF8B949E);

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF4F7F6), // Soft off-white background
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          secondary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF1E293B), // Dark blue-gray text
          onSecondary: Color(0xFF64748B), // Gray secondary text
          error: Color(0xFFEA7979),
          tertiary: Color(0xFF94A3B8), // Lighter gray for icons
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F7F6),
          foregroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: primaryBlue, fontSize: 12, fontWeight: FontWeight.bold);
            }
            return const TextStyle(color: Color(0xFF94A3B8), fontSize: 12);
          }),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(foregroundColor: primaryBlue),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: primaryBlue,
          secondary: cardDark,
          surface: cardDark,
          onSurface: Colors.white,
          onSecondary: textGray,
          error: Color(0xFFEA7979),
          tertiary: textGray,
        ),
        cardTheme: CardThemeData(
          color: cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundDark,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: backgroundDark,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: primaryBlue, fontSize: 12, fontWeight: FontWeight.bold);
            }
            return const TextStyle(color: textGray, fontSize: 12);
          }),
        ),
      );
}
