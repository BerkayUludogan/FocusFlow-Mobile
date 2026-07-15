import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/features/auth/data/models/register_request.dart';
import 'package:focusflow_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:focusflow_mobile/features/auth/domain/constants/auth_error_messages.dart';
import 'package:focusflow_mobile/features/auth/presentation/cubit/register_state.dart';
import 'package:focusflow_mobile/product/state/base_cubit.dart';

class RegisterCubit extends BaseCubit<RegisterState> {
  RegisterCubit({required this._authRepository}) : super(const RegisterState());

  final AuthRepository _authRepository;

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(const RegisterState(status: RegisterStatus.loading));

    try {
      await _authRepository.register(
        RegisterRequest(
          email: email,
          password: password,
          displayName: displayName,
        ),
      );
      emit(RegisterState(status: RegisterStatus.success));
    } catch (e) {
      emit(
        RegisterState(
          status: RegisterStatus.failure,
          errorMessage: e is ApiException
              ? e.toString()
              : AuthErrorMessages.registerFailed,
        ),
      );
    }
  }
}
