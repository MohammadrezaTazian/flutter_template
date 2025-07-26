import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:my_app/l10n/app_localizations.dart';

class FontSizeAdjuster extends StatelessWidget {
  const FontSizeAdjuster({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        // تبدیل scale به نام محلی‌سازی شده
        String getLocalizedFontSizeName(double scale) {
          switch (scale.toStringAsFixed(1)) {
            case '0.8':
              return localizations.small;
            case '1.0':
              return localizations.medium;
            case '1.2':
              return localizations.large;
            case '1.4':
              return localizations.extraLarge;
            default:
              return localizations.medium;
          }
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.fontSize,
                  style: TextStyle(fontSize: 16 * state.fontSizeScale),
                ),
                Row(
                  children: [
                    // دکمه کاهش اندازه فونت
                    ElevatedButton(
                      onPressed: () {
                        double newScale = state.fontSizeScale - 0.2;
                        if (newScale >= 0.8) {
                          context.read<SettingsBloc>().add(
                                FontSizeChanged(newScale),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        minimumSize: const Size(40, 40),
                      ),
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 16),
                    
                    // نمایش نام اندازه فونت
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getLocalizedFontSizeName(state.fontSizeScale),
                        style: TextStyle(
                          fontSize: 14 * state.fontSizeScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // دکمه افزایش اندازه فونت
                    ElevatedButton(
                      onPressed: () {
                        double newScale = state.fontSizeScale + 0.2;
                        if (newScale <= 1.4) {
                          context.read<SettingsBloc>().add(
                                FontSizeChanged(newScale),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        minimumSize: const Size(40, 40),
                      ),
                      child: const Icon(Icons.add),
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