import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/database_service.dart';

part 'provider.g.dart';

// Database Service Provider
@riverpod
DatabaseService databaseService(DatabaseServiceRef ref) {
  return DatabaseService();
}

// Theme Mode Provider (Dark/Light)
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

// Font Size Provider
@riverpod
class FontSizeNotifier extends _$FontSizeNotifier {
  @override
  double build() {
    return 16.0; // Default font size
  }

  void setFontSize(double size) {
    state = size;
  }
}

// Convenience providers for easier access
final themeModeProvider = themeModeNotifierProvider;
final fontSizeProvider = fontSizeNotifierProvider;