import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/core/routing/app_router.dart';
import 'package:focusflow_mobile/features/auth/presentation/widgets/button_loading_indicator.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../mixins/auth_form_validators_mixin.dart';
import '../mixins/register_view_mixin.dart';
import '../widgets/auth_page_scaffold.dart';
import '../widgets/password_form_field.dart';
import 'email_verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with AuthFormValidatorsMixin, RegisterViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => registerCubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.success) {
            context.push(
              AppRoutes.verifyEmail,
              extra: EmailVerificationArgs(email: emailController.text.trim()),
            );
          }

          if (state.status == RegisterStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.error,
                content: Text(state.errorMessage!),
              ),
            );
          }
        },
        builder: (context, state) {
          return AuthPageScaffold(
            formKey: formKey,
            icon: Icons.person_add_alt_1_rounded,
            title: LocaleKeys.authRegisterTitle.tr(),
            children: [
              TextFormField(
                controller: displayNameController,
                validator: validateDisplayName,
                decoration: InputDecoration(
                  labelText: LocaleKeys.authDisplayNameLabel.tr(),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: WidgetSizes.textFieldSpacing),
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
              const SizedBox(height: WidgetSizes.textFieldSpacing),
              PasswordFormField(
                controller: confirmPasswordController,
                labelText: LocaleKeys.authConfirmPasswordLabel.tr(),
                validator: validateConfirmPassword,
              ),
              const SizedBox(height: WidgetSizes.sectionSpacing),
              SizedBox(
                width: double.infinity,
                height: WidgetSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : register,
                  child: state.isLoading
                      ? const ButtonLoadingIndicator()
                      : Text(LocaleKeys.authRegisterButton.tr()),
                ),
              ),
              const SizedBox(height: WidgetSizes.textFieldSpacing),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(LocaleKeys.authHaveAccount.tr()),
              ),
            ],
          );
        },
      ),
    );
  }
}
