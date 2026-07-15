import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/features/auth/data/repositories/auth_repository.dart';

import '../cubit/email_verification_cubit.dart';
import '../pages/email_verification_page.dart';

mixin EmailVerificationViewMixin on State<EmailVerificationPage> {
  static const _resendCooldownSeconds = 60;

  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();

  late final EmailVerificationCubit verificationCubit;

  Timer? _resendTimer;
  int secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    verificationCubit = EmailVerificationCubit(
      authRepository: context.read<AuthRepository>(),
    );
    secondsRemaining = _resendCooldownSeconds;
    _startCountdownTimer();
  }

  @override
  void dispose() {
    codeController.dispose();
    verificationCubit.close();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining <= 1) {
        timer.cancel();
        setState(() => secondsRemaining = 0);
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  Future<void> verify() async {
    if (!formKey.currentState!.validate()) return;
    await verificationCubit.verifyEmail(
      email: widget.email,
      code: codeController.text.trim(),
    );
  }

  Future<void> resendCode() async {
    await verificationCubit.resendCode(email: widget.email);
    setState(() => secondsRemaining = _resendCooldownSeconds);
    _startCountdownTimer();
  }
}
