import 'package:easy_localization/easy_localization.dart';

import '../../../../product/localization/locale_keys.dart';

class AuthErrorMessages {
  const AuthErrorMessages._();

  static String get loginFailed => LocaleKeys.authLoginFailed.tr();
  static String get registerFailed => LocaleKeys.authRegisterFailed.tr();
  static String get logoutFailed => LocaleKeys.authLogoutFailed.tr();
  static String get verifyEmailFailed => LocaleKeys.authVerifyEmailFailed.tr();
  static String get resendCodeFailed => LocaleKeys.authResendCodeFailed.tr();
  static String get sessionCheckFailed =>
      LocaleKeys.authSessionCheckFailed.tr();
}
