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
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          secondary: Color(0xFFD5E9ED),
          surface: Colors.white,
          onSurface: Color(0xFF414A4C),
          error: Color(0xFFEA7979),
          tertiary: Color(0XFFB5C4C7),
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
