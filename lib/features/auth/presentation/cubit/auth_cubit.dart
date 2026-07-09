import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/login_request.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/constants/auth_error_messages.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this._authRepository}) : super(const AuthState());

  final AuthRepository _authRepository;

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
        const AuthState(
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
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: error.toString().isNotEmpty
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
      const AuthState(
        status: AuthStatus.failure,
        errorMessage: AuthErrorMessages.logoutFailed,
      );
    }
  }
}