import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/utils/gen/assets.gen.dart';
import 'package:my_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:my_app/features/home/presentation/bloc/home_state.dart';
import 'package:my_app/l10n/app_localizations.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.images.icons.home.svg(
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.welcomeMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                if (state is HomeLoading)
                  const CircularProgressIndicator()
                else if (state is HomeLoaded)
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}