part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Locale locale;

  const SettingsState({required this.locale});

  @override
  List<Object> get props => [locale];
}
