import 'package:go_router/go_router.dart';
import 'package:flutter_template/presentation/home/pages/home_page.dart';
import 'package:flutter_template/presentation/settings/pages/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
