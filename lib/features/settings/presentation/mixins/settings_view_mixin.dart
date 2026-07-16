import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/features/auth/presentation/cubit/auth_cubit.dart';

import '../pages/settings_page.dart';

mixin SettingsViewMixin on State<SettingsPage> {
  Future<void> logout() async {
    await context.read<AuthCubit>().logout();
  }
}
