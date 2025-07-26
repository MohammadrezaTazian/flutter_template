import 'package:flutter/material.dart';
import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';

class SetLanguage {
  final SettingsRepository repository;

  SetLanguage(this.repository);

  Future<void> call(Locale locale) async {
    return await repository.setLanguage(locale);
  }
}