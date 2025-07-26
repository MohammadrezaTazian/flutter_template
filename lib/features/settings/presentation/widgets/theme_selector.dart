import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:my_app/l10n/app_localizations.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.display,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.darkTheme),
                  value: ThemeMode.light,
                  groupValue: state.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      context
                          .read<SettingsBloc>()
                          .add(ThemeChanged(value));
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.darkTheme),
                  value: ThemeMode.dark,
                  groupValue: state.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      context
                          .read<SettingsBloc>()
                          .add(ThemeChanged(value));
                    }
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}