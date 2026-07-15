import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/features/auth/presentation/pages/email_verification_page.dart';
import 'package:focusflow_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter({required AuthCubit authCubit})
    : router = GoRouter(
        initialLocation: AppRoutes.splash,
        refreshListenable: GoRouterRefreshStream(authCubit.stream),

        redirect: (BuildContext context, GoRouterState state) {
          final authStatus = authCubit.state.status;
          final location = state.uri.path;

          final isSplash = location == AppRoutes.splash;
          final isLogin = location == AppRoutes.login;

          final isRegister = location == AppRoutes.register;
          final isVerifyEmail = location == AppRoutes.verifyEmail;
          final isAuthRoute = isLogin || isRegister || isVerifyEmail;

          if (authStatus == AuthStatus.initial) {
            return isSplash ? null : AppRoutes.splash;
          }

          if (authStatus == AuthStatus.loading) {
            return null;
          }

          if (authStatus == AuthStatus.authenticated) {
            return isAuthRoute || isSplash ? AppRoutes.home : null;
          }

          if (authStatus == AuthStatus.unauthenticated ||
              authStatus == AuthStatus.failure) {
            return isAuthRoute ? null : AppRoutes.login;
          }

          return null;
        },
        errorBuilder: (context, state) => Scaffold(
          body: Center(child: Text(LocaleKeys.routingPageNotFound.tr())),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            builder: (context, state) => const SplashPage(),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.register,
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: AppRoutes.verifyEmail,
            builder: (context, state) =>
                EmailVerificationPage(email: state.extra as String),
          ),
        ],
      );

  final GoRouter router;
}

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
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
