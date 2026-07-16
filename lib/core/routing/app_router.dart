import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focusflow_mobile/features/settings/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import 'app_redirect.dart';
import 'app_routes.dart';
import 'app_shell_routes.dart';
import 'auth_routes.dart';
import 'not_found_page.dart';

export 'app_routes.dart';

class AppRouter {
  AppRouter({required AuthCubit authCubit})
    : router = GoRouter(
        initialLocation: AppRoutes.splash,
        refreshListenable: GoRouterRefreshStream(authCubit.stream),
        redirect: (context, state) => appRedirect(authCubit, state),
        errorBuilder: (context, state) => const NotFoundPage(),
        routes: [
          ...authRoutes,
          appShellRoute,
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      );

  final GoRouter router;
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
