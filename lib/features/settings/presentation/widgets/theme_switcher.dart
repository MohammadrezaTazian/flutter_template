import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:my_app/l10n/app_localizations.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.display,
                  style: TextStyle(fontSize: 16 * state.fontSizeScale),
                ),
                Row(
                  children: [
                    Text(
                      localizations.darkTheme,
                      style: TextStyle(fontSize: 16 * state.fontSizeScale),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: state.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                              ThemeChanged(value ? ThemeMode.dark : ThemeMode.light),
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}