// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeMessage => 'Welcome to our application!';

  @override
  String get homeTitle => 'Home';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get display => 'Display';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get fontSize => 'Font Size';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get newContentNotifications => 'New content notifications';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get extraLarge => 'Extra Large';
}
