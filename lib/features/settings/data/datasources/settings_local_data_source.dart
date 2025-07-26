import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<ThemeMode> getThemeMode();
  Future<Locale> getLanguage();
  Future<double> getFontSizeScale();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<void> setLanguage(Locale locale);
  Future<void> setFontSizeScale(double scale);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeModeString = sharedPreferences.getString('theme_mode') ?? 'system';
    switch (themeModeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<Locale> getLanguage() async {
    final languageCode = sharedPreferences.getString('language_code') ?? 'en';
    return Locale(languageCode);
  }

  @override
  Future<double> getFontSizeScale() async {
    return sharedPreferences.getDouble('font_size_scale') ?? 1.0;
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    final themeModeString = themeMode.toString().split('.').last;
    await sharedPreferences.setString('theme_mode', themeModeString);
  }

  @override
  Future<void> setLanguage(Locale locale) async {
    await sharedPreferences.setString('language_code', locale.languageCode);
  }

  @override
  Future<void> setFontSizeScale(double scale) async {
    await sharedPreferences.setDouble('font_size_scale', scale);
  }
}