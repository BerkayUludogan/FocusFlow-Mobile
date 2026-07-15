import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

import '../cubit/register_cubit.dart';
import '../pages/register_page.dart';

mixin RegisterViewMixin on State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late final RegisterCubit registerCubit;

  @override
  void initState() {
    super.initState();
    registerCubit = RegisterCubit(
      authRepository: context.read<AuthRepository>(),
    );
  }

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    registerCubit.close();
    super.dispose();
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return LocaleKeys.authPasswordMismatch.tr();
    }
    return null;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    await registerCubit.register(
      email: emailController.text.trim(),
      password: passwordController.text,
      displayName: displayNameController.text.trim(),
    );
  }
}
