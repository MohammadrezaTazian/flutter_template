import 'package:flutter/material.dart';
import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';

class SetThemeMode {
  final SettingsRepository repository;

  SetThemeMode(this.repository);

  Future<void> call(ThemeMode themeMode) async {
    return await repository.setThemeMode(themeMode);
  }
}