import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/core/routing/app_router.dart';
import 'package:focusflow_mobile/features/auth/presentation/widgets/button_loading_indicator.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../mixins/auth_form_validators_mixin.dart';
import '../mixins/login_view_mixin.dart';
import '../widgets/auth_page_scaffold.dart';
import '../widgets/password_form_field.dart';
import 'email_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AuthFormValidatorsMixin, LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.shortBreak,
              content: Text(LocaleKeys.authLoginSuccess.tr()),
            ),
          );
        }

        if (state.status == AuthStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(state.errorMessage!),
            ),
          );
        }

        if (state.status == AuthStatus.emailNotVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(LocaleKeys.authEmailNotVerified.tr()),
            ),
          );
          context.push(
            AppRoutes.verifyEmail,
            extra: EmailVerificationArgs(
              email: emailController.text.trim(),
              canCancel: true,
            ),
          );
        }
      },
      builder: (context, state) {
        return AuthPageScaffold(
          formKey: formKey,
          icon: Icons.timer_rounded,
          title: LocaleKeys.authLoginTitle.tr(),
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              decoration: InputDecoration(
                labelText: LocaleKeys.authEmailLabel.tr(),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: WidgetSizes.textFieldSpacing),
            PasswordFormField(
              controller: passwordController,
              labelText: LocaleKeys.authPasswordLabel.tr(),
              validator: validatePassword,
            ),
            const SizedBox(height: WidgetSizes.sectionSpacing),
            SizedBox(
              width: double.infinity,
              height: WidgetSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : login,
                child: state.isLoading
                    ? const ButtonLoadingIndicator()
                    : Text(LocaleKeys.authLoginButton.tr()),
              ),
            ),
            const SizedBox(height: WidgetSizes.textFieldSpacing),
            TextButton(
              onPressed: () => context.go(AppRoutes.register),
              child: Text(LocaleKeys.authNoAccount.tr()),
            ),
          ],
        );
      },
    );
  }
}
