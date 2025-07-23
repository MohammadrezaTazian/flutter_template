abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {
  final bool isDark;
  ToggleTheme(this.isDark);
}