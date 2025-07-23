import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.select((SettingsBloc bloc) => bloc.state.locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Language:', style: Theme.of(context).textTheme.titleLarge),
        RadioListTile<Locale>(
          title: const Text('فارسی'),
          value: const Locale('fa'),
          groupValue: currentLocale,
          onChanged: (locale) {
            context.read<SettingsBloc>().add(LanguageChanged(locale!));
          },
        ),
        RadioListTile<Locale>(
          title: const Text('English'),
          value: const Locale('en'),
          groupValue: currentLocale,
          onChanged: (locale) {
            context.read<SettingsBloc>().add(LanguageChanged(locale!));
          },
        ),
      ],
    );
  }
}
