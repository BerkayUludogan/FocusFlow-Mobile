import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: AppRoutes.login,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.register,
    builder: (context, state) => const RegisterPage(),
  ),
  GoRoute(
    path: AppRoutes.verifyEmail,
    // Reachable only via an explicit push with EmailVerificationArgs as
    // extra (from register/login). A deep link, restored navigation state,
    // or hot restart can hit this path with no/wrong extra, so redirect to
    // login instead of letting the builder's cast crash.
    redirect: (context, state) =>
        state.extra is EmailVerificationArgs ? null : AppRoutes.login,
    builder: (context, state) {
      final args = state.extra! as EmailVerificationArgs;
      return EmailVerificationPage(
        email: args.email,
        canCancel: args.canCancel,
      );
    },
  ),
];
