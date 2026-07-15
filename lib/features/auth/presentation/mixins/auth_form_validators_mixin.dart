import 'package:easy_localization/easy_localization.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

mixin AuthFormValidatorsMixin {
  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return LocaleKeys.authEmailRequired.tr();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) return LocaleKeys.authEmailInvalid.tr();
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return LocaleKeys.authPasswordRequired.tr();
    if (password.length < 8) return LocaleKeys.authPasswordTooShort.tr();
    return null;
  }

  String? validateDisplayName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return LocaleKeys.authDisplayNameRequired.tr();
    if (name.length < 2) return LocaleKeys.authDisplayNameTooShort.tr();
    return null;
  }

  String? validateCode(String? value) {
    final code = value?.trim() ?? '';
    if (code.isEmpty) return LocaleKeys.authCodeRequired.tr();
    return null;
  }
}
