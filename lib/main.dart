import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/config/router/app_router.dart';
import 'package:flutter_template/core/locale/bloc/locale_bloc.dart';
import 'package:flutter_template/core/locale/bloc/locale_state.dart';
import 'package:flutter_template/core/localizations/app_localizations.dart';
import 'package:flutter_template/core/localizations/localization_config.dart';
import 'package:flutter_template/core/theme/bloc/theme_bloc.dart';
import 'package:flutter_template/core/theme/bloc/theme_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => LocaleBloc()),
      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeState.themeMode,
              locale: localeState.locale,
              supportedLocales: LocalizationConfig.supportedLocales,
              localizationsDelegates: [
                AppLocalizations.delegate,
                ...LocalizationConfig.localizationsDelegates,
              ],
              routerConfig: appRouter,
            );
          },
        );
      },
    );
  }
}
