import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:my_app/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.language,
                  style: TextStyle(fontSize: 16 * state.fontSizeScale),
                ),
                const SizedBox(height: 10),
                RadioListTile<Locale>(
                  title: Text(
                    'فارسی',
                    style: TextStyle(fontSize: 16 * state.fontSizeScale),
                  ),
                  value: const Locale('fa'),
                  groupValue: state.locale,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      context.read<SettingsBloc>().add(LanguageChanged(value));
                    }
                  },
                ),
                RadioListTile<Locale>(
                  title: Text(
                    'English',
                    style: TextStyle(fontSize: 16 * state.fontSizeScale),
                  ),
                  value: const Locale('en'),
                  groupValue: state.locale,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      context.read<SettingsBloc>().add(LanguageChanged(value));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}