import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:my_app/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:my_app/features/settings/domain/usecases/get_language.dart';
import 'package:my_app/features/settings/domain/usecases/get_font_size.dart';
import 'package:my_app/features/settings/domain/usecases/set_theme_mode.dart';
import 'package:my_app/features/settings/domain/usecases/set_language.dart';
import 'package:my_app/features/settings/domain/usecases/set_font_size.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetThemeMode getThemeMode;
  final GetLanguage getLanguage;
  final GetFontSizeScale getFontSizeScale;
  final SetThemeMode setThemeMode;
  final SetLanguage setLanguage;
  final SetFontSizeScale setFontSizeScale;

  SettingsBloc({
    required this.getThemeMode,
    required this.getLanguage,
    required this.getFontSizeScale,
    required this.setThemeMode,
    required this.setLanguage,
    required this.setFontSizeScale,
  }) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ThemeChanged>(_onThemeChanged);
    on<LanguageChanged>(_onLanguageChanged);
    on<FontSizeChanged>(_onFontSizeChanged);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final themeMode = await getThemeMode();
      final locale = await getLanguage();
      final fontSizeScale = await getFontSizeScale();
      emit(state.copyWith(
        themeMode: themeMode,
        locale: locale,
        fontSizeScale: fontSizeScale,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onThemeChanged(ThemeChanged event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(themeMode: event.themeMode));
    await setThemeMode(event.themeMode);
  }

  void _onLanguageChanged(LanguageChanged event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(locale: event.locale));
    await setLanguage(event.locale);
  }

  void _onFontSizeChanged(FontSizeChanged event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(fontSizeScale: event.fontSizeScale));
    await setFontSizeScale(event.fontSizeScale);
  }
}