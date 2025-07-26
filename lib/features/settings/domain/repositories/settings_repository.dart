import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<ThemeMode> getThemeMode();
  Future<Locale> getLanguage();
  Future<double> getFontSizeScale();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<void> setLanguage(Locale locale);
  Future<void> setFontSizeScale(double scale);
}