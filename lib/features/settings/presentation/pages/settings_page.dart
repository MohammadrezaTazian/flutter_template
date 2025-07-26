import 'package:flutter/material.dart';
import 'package:my_app/features/settings/presentation/widgets/theme_switcher.dart';
import 'package:my_app/features/settings/presentation/widgets/font_size_adjuster.dart';
import 'package:my_app/features/settings/presentation/widgets/language_selector.dart';
import 'package:my_app/features/settings/presentation/widgets/notification_switcher.dart';
import 'package:my_app/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تم نمایش
            ThemeSwitcher(),
            SizedBox(height: 20),

            // اندازه فونت
            FontSizeAdjuster(),
            SizedBox(height: 20),

            // زبان
            LanguageSelector(),
            SizedBox(height: 20),

            // اعلان‌ها
            NotificationSwitcher(),
          ],
        ),
      ),
    );
  }
}