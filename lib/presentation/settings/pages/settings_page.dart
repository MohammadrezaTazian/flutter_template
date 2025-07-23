import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/locale/bloc/locale_bloc.dart';
import 'package:flutter_template/core/locale/bloc/locale_event.dart';
import 'package:flutter_template/core/locale/bloc/locale_state.dart';
import 'package:flutter_template/core/localizations/app_localizations.dart';
import 'package:flutter_template/core/theme/bloc/theme_bloc.dart';
import 'package:flutter_template/core/theme/bloc/theme_event.dart';
import 'package:flutter_template/core/theme/bloc/theme_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // بخش انتخاب زبان
            BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(localizations.language),
                    DropdownButton<Locale>(
                      value: state.locale,
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          context.read<LocaleBloc>().add(ChangeLocale(newLocale));
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: Locale('fa'),
                          child: Text('فارسی'),
                        ),
                        DropdownMenuItem(
                          value: Locale('en'),
                          child: Text('English'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // بخش انتخاب تم
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final isDark = state.themeMode == ThemeMode.dark;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(localizations.theme),
                    Switch(
                      value: isDark,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(ToggleTheme(value));
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
