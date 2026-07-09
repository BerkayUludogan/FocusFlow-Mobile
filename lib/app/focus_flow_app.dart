// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/core/routing/app_router.dart';

import 'package:focusflow_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:focusflow_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_theme.dart';

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) => AuthCubit(authRepository: authRepository),
        child: MaterialApp.router(
          onGenerateTitle: (_) => LocaleKeys.appName.tr(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: AppRouter.router,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      ),
    );
  }
}
