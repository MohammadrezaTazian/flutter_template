import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';

class GetFontSizeScale {
  final SettingsRepository repository;

  GetFontSizeScale(this.repository);

  Future<double> call() async {
    return await repository.getFontSizeScale();
  }
}