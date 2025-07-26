import 'package:flutter/material.dart';
import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_app/features/settings/data/datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<ThemeMode> getThemeMode() async {
    return await localDataSource.getThemeMode();
  }

  @override
  Future<Locale> getLanguage() async {
    return await localDataSource.getLanguage();
  }

  @override
  Future<double> getFontSizeScale() async {
    return await localDataSource.getFontSizeScale();
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    return await localDataSource.setThemeMode(themeMode);
  }

  @override
  Future<void> setLanguage(Locale locale) async {
    return await localDataSource.setLanguage(locale);
  }

  @override
  Future<void> setFontSizeScale(double scale) async {
    return await localDataSource.setFontSizeScale(scale);
  }
}