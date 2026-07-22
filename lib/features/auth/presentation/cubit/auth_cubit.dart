import 'dart:async';

import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/product/state/base_cubit.dart';
import '../../data/models/login_request.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/constants/auth_error_messages.dart';
import 'auth_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit({required this._authRepository}) : super(const AuthState()) {
    // A dead refresh token means the session is over regardless of what
    // screen the user is currently on — drop straight to unauthenticated
    // so the router sends them back to login instead of leaving them
    // stuck on a request that can never succeed again.
    _sessionExpiredSubscription = _authRepository.sessionExpired.listen((_) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<void> _sessionExpiredSubscription;

  // The backend (see FocusFlow-API's ErrorMessageResolver) has no distinct
  // error code for this case — login failures are all HTTP 422 with only a
  // human-readable message, so an exact string match is the only way to
  // tell "email not verified" apart from "wrong email/password". Turkish
  // only; there's no English backend message to match against yet.
  static const _emailNotVerifiedMessage =
      'Email adresinizi doğrulamanız gerekiyor.';

  Future<void> checkSession() async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      final hasToken = await _authRepository.hasToken();

      emit(
        AuthState(
          status: hasToken
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
        ),
      );
    } catch (_) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: AuthErrorMessages.sessionCheckFailed,
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      await _authRepository.login(
        LoginRequest(email: email, password: password),
      );

      emit(const AuthState(status: AuthStatus.authenticated));
    } catch (error) {
      if (error is ApiException && error.errors.contains(_emailNotVerifiedMessage)) {
        emit(const AuthState(status: AuthStatus.emailNotVerified));
        return;
      }

      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: error is ApiException
              ? error.toString()
              : AuthErrorMessages.loginFailed,
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      await _authRepository.logout();

      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (_) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: AuthErrorMessages.logoutFailed,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _sessionExpiredSubscription.cancel();
    return super.close();
  }
}
