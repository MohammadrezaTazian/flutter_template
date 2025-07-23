part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends SettingsEvent {
  final Locale locale;

  const LanguageChanged(this.locale);

  @override
  List<Object> get props => [locale];
}
