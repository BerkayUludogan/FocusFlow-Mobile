import 'package:easy_localization/easy_localization.dart';

import '../../../../product/localization/locale_keys.dart';

class AuthErrorMessages {
  const AuthErrorMessages._();

  static String get loginFailed => LocaleKeys.authLoginFailed.tr();
  static String get logoutFailed => LocaleKeys.authLogoutFailed.tr();
  static String get sessionCheckFailed => LocaleKeys.authSessionCheckFailed.tr();
}