import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme(double fontSize) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme(fontSize, Brightness.light),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(double fontSize) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      textTheme: _buildTextTheme(fontSize, Brightness.dark),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  // Build Text Theme based on font size
  static TextTheme _buildTextTheme(double fontSize, Brightness brightness) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: fontSize + 16),
      displayMedium: TextStyle(fontSize: fontSize + 12),
      displaySmall: TextStyle(fontSize: fontSize + 8),
      headlineLarge: TextStyle(fontSize: fontSize + 10),
      headlineMedium: TextStyle(fontSize: fontSize + 6),
      headlineSmall: TextStyle(fontSize: fontSize + 4),
      titleLarge: TextStyle(
        fontSize: fontSize + 6,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: fontSize + 2,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(fontSize: fontSize),
      bodyMedium: TextStyle(fontSize: fontSize - 2),
      bodySmall: TextStyle(fontSize: fontSize - 4),
      labelLarge: TextStyle(fontSize: fontSize),
      labelMedium: TextStyle(fontSize: fontSize - 2),
      labelSmall: TextStyle(fontSize: fontSize - 4),
    );
  }
}