import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/settings/domain/entities/font_size.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';

class FontSizeSelector extends StatelessWidget {
  const FontSizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اندازه فونت',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Column(
              children: FontSize.getFontSizes().map((fontSize) {
                return RadioListTile<double>(
                  title: Text(
                    fontSize.name,
                    style: TextStyle(
                      fontSize: 16 * fontSize.scale,
                    ),
                  ),
                  value: fontSize.scale,
                  groupValue: state.fontSizeScale,
                  onChanged: (double? value) {
                    if (value != null) {
                      context
                          .read<SettingsBloc>()
                          .add(FontSizeChanged(value));
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}