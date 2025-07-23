import 'package:flutter/material.dart';
import 'package:flutter_template/core/localizations/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.hello)),
      body: Center(child: Text(localizations.welcome)),
    );
  }
}
