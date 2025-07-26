import 'package:flutter/material.dart';
import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';

class GetLanguage {
  final SettingsRepository repository;

  GetLanguage(this.repository);

  Future<Locale> call() async {
    return await repository.getLanguage();
  }
}