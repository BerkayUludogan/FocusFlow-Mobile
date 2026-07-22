import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import 'app_routes.dart';

String? appRedirect(AuthCubit authCubit, GoRouterState state) {
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
    return isAuthRoute || isSplash ? AppRoutes.timer : null;
  }

  if (authStatus == AuthStatus.unauthenticated ||
      authStatus == AuthStatus.failure ||
      authStatus == AuthStatus.emailNotVerified) {
    return isAuthRoute ? null : AppRoutes.login;
  }

  return null;
}
