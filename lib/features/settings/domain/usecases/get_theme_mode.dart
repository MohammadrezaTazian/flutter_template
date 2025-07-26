import 'package:flutter/material.dart';
import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';

class GetThemeMode {
  final SettingsRepository repository;

  GetThemeMode(this.repository);

  Future<ThemeMode> call() async {
    return await repository.getThemeMode();
  }
}