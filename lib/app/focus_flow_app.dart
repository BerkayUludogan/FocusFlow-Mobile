import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/routing/app_router.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../product/localization/locale_keys.dart';
import '../product/theme/app_theme.dart';

class FocusFlowApp extends StatefulWidget {
  const FocusFlowApp({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  State<FocusFlowApp> createState() => _FocusFlowAppState();
}

class _FocusFlowAppState extends State<FocusFlowApp> {
  late final AuthCubit _authCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    _authCubit = AuthCubit(authRepository: widget.authRepository);
    _appRouter = AppRouter(authCubit: _authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget.authRepository,
      child: BlocProvider.value(
        value: _authCubit,
        child: MaterialApp.router(
          onGenerateTitle: (_) => LocaleKeys.appName.tr(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: _appRouter.router,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      ),
    );
  }
}
