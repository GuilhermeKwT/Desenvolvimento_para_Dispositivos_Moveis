import 'package:flutter/material.dart';

class AppTheme {
  // App colors (current theme)
  static const Color primaryPurple = Color.fromARGB(255, 70, 10, 168);
  static const Color secondaryGray = Color.fromARGB(255, 42, 40, 44);
  static const Color darkGray = Color.fromARGB(255, 48, 48, 48);
  static const Color accentGray = Color.fromARGB(180, 48, 48, 48);
  static const Color borderGray = Color.fromARGB(120, 0, 0, 0);

  // Card colors
  static const Color cardGradientStart = Color.fromARGB(238, 61, 61, 61);
  static const Color cardGradientEnd = Color.fromARGB(239, 32, 31, 34);
  static const Color cardShadow = Colors.black;

  // Input field colors
  static const Color inputFillColor = Colors.white;
  static const Color inputLabelColor = Colors.white;
  static const Color dropdownColor = Color.fromARGB(255, 48, 48, 48);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  // Other UI colors
  static const Color plateBadgeBackground = Colors.black26;
  static const Color imagePlaceholderColor = Colors.black12;

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryPurple,
      onPrimary: Colors.white,
      secondary: secondaryGray,
      onSecondary: Colors.white,
      tertiary: darkGray,
      onTertiary: Colors.white,
      error: const Color.fromARGB(255, 255, 68, 68),
      onError: Colors.white,
      surface: secondaryGray,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: accentGray,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
    ),
  );

  // Gradients
  static const LinearGradient appGradient = LinearGradient(
    colors: [
      primaryPurple,
      secondaryGray,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 15.0;

  // Spacing
  static const double spacingSmall = 6.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 14.0;
}
