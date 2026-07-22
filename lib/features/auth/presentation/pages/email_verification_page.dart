import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/core/routing/app_router.dart';
import 'package:focusflow_mobile/features/auth/presentation/widgets/button_loading_indicator.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../cubit/email_verification_cubit.dart';
import '../cubit/email_verification_state.dart';
import '../mixins/auth_form_validators_mixin.dart';
import '../mixins/email_verification_view_mixin.dart';
import '../widgets/auth_page_scaffold.dart';

class EmailVerificationArgs {
  const EmailVerificationArgs({required this.email, this.canCancel = false});

  final String email;

  // True when the user landed here because an existing (unverified) account
  // tried to log in — they should be able to back out and try a different
  // account. False for the post-register flow, where verification is
  // mandatory and there is nothing sensible to go back to.
  final bool canCancel;
}

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({required this.email, this.canCancel = false, super.key});

  final String email;
  final bool canCancel;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with AuthFormValidatorsMixin, EmailVerificationViewMixin {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Verification is a required step of registration, not a page to
      // idly back out of — swiping/back-buttoning away would strand the
      // account in an unverified, unusable state. When we got here from a
      // login attempt on an existing unverified account, though, the user
      // should be able to back out and try a different account.
      canPop: widget.canCancel,
      child: BlocProvider(
        create: (_) => verificationCubit,
        child: BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
          listener: (context, state) {
            if (state.status == EmailVerificationStatus.verified) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.shortBreak,
                  content: Text(LocaleKeys.authEmailVerified.tr()),
                ),
              );
              context.go(AppRoutes.login);
            }

            if (state.status == EmailVerificationStatus.verifyFailed &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.error,
                  content: Text(state.errorMessage!),
                ),
              );
            }

            if (state.status == EmailVerificationStatus.resendSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.shortBreak,
                  content: Text(LocaleKeys.authCodeResent.tr()),
                ),
              );
            }

            if (state.status == EmailVerificationStatus.resendFailed &&
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
              icon: Icons.mark_email_read_outlined,
              title: LocaleKeys.authVerifyEmailTitle.tr(),
              subtitle: LocaleKeys.authVerifyEmailSubtitle.tr(
                args: [widget.email],
              ),
              children: [
                TextFormField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: validateCode,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.authCodeLabel.tr(),
                    prefixIcon: const Icon(Icons.pin_outlined),
                  ),
                ),
                const SizedBox(height: WidgetSizes.sectionSpacing),
                SizedBox(
                  width: double.infinity,
                  height: WidgetSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: state.isVerifying ? null : verify,
                    child: state.isVerifying
                        ? const ButtonLoadingIndicator()
                        : Text(LocaleKeys.authVerifyButton.tr()),
                  ),
                ),
                const SizedBox(height: WidgetSizes.textFieldSpacing),
                TextButton(
                  onPressed: (state.isResending || secondsRemaining > 0)
                      ? null
                      : resendCode,
                  child: Text(
                    secondsRemaining > 0
                        ? LocaleKeys.authResendCodeIn.tr(
                            args: [secondsRemaining.toString()],
                          )
                        : LocaleKeys.authResendCode.tr(),
                  ),
                ),
                if (widget.canCancel) ...[
                  const SizedBox(height: WidgetSizes.textFieldSpacing),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(LocaleKeys.authBackToLogin.tr()),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
