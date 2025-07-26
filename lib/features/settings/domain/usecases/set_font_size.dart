import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';

class SetFontSizeScale {
  final SettingsRepository repository;

  SetFontSizeScale(this.repository);

  Future<void> call(double scale) async {
    return await repository.setFontSizeScale(scale);
  }
}