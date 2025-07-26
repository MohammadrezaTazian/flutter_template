import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'core/constants/routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/otp_verification_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<SettingsBloc>()..add( LoadSettings()),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<AuthBloc>(),
          lazy: false, // مهم: ایجاد فوری Bloc
        ),
      ],
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return MaterialApp(
          title: 'My App',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Vazir',
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 16 * settingsState.fontSizeScale),
              bodyMedium: TextStyle(fontSize: 14 * settingsState.fontSizeScale),
              bodySmall: TextStyle(fontSize: 12 * settingsState.fontSizeScale),
              headlineSmall: TextStyle(fontSize: 20 * settingsState.fontSizeScale),
              titleLarge: TextStyle(fontSize: 22 * settingsState.fontSizeScale),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: 'Vazir',
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 16 * settingsState.fontSizeScale),
              bodyMedium: TextStyle(fontSize: 14 * settingsState.fontSizeScale),
              bodySmall: TextStyle(fontSize: 12 * settingsState.fontSizeScale),
              headlineSmall: TextStyle(fontSize: 20 * settingsState.fontSizeScale),
              titleLarge: TextStyle(fontSize: 22 * settingsState.fontSizeScale),
            ),
          ),
          themeMode: settingsState.themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('fa'),
          ],
          locale: settingsState.locale,
          initialRoute: Routes.login,
          routes: {
            Routes.home: (context) => const HomePage(),
            Routes.settings: (context) => const SettingsPage(),
            Routes.login: (context) => const LoginPage(),
            Routes.otpVerification: (context) => const OtpVerificationPage(),
            Routes.profile: (context) => const ProfilePage(),
          },
        );
      },
    );
  }
}