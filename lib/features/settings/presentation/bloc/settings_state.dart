import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final double fontSizeScale;
  final bool isLoading;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.fontSizeScale = 1.0,
    this.isLoading = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    double? fontSizeScale,
    bool? isLoading,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [themeMode, locale, fontSizeScale, isLoading];
}