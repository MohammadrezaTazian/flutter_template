import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/constants/routes.dart';
import 'package:my_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:my_app/features/home/presentation/bloc/home_event.dart';
import 'package:my_app/features/home/presentation/widgets/welcome_widget.dart';
import 'package:my_app/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeTitle),
        actions: [
          // دکمه پروفایل
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, Routes.profile);
            },
          ),
          // دکمه تنظیمات
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
        ],
      ),
      body: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const LoadWelcomeMessage()),
      child: const WelcomeWidget(),
    );
  }
}