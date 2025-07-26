import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:my_app/l10n/app_localizations.dart';

class NotificationSwitcher extends StatelessWidget {
  const NotificationSwitcher({super.key});

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
                  localizations.notifications,
                  style: TextStyle(fontSize: 16 * state.fontSizeScale),
                ),
                Row(
                  children: [
                    Text(
                      localizations.newContentNotifications,
                      style: TextStyle(fontSize: 16 * state.fontSizeScale),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: true, // اینجا می‌توانید وضعیت اصلی اعلام‌ها را ذخیره کنید
                      onChanged: (value) {
                        // اینجا عملیات ذخیره‌سازی وضعیت اعلام‌ها را انجام دهید
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