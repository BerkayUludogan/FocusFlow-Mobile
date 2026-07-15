import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/features/auth/data/models/resend_verification_code_request.dart';
import 'package:focusflow_mobile/features/auth/data/models/verify_email_request.dart';
import 'package:focusflow_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:focusflow_mobile/features/auth/domain/constants/auth_error_messages.dart';
import 'package:focusflow_mobile/features/auth/presentation/cubit/email_verification_state.dart';
import 'package:focusflow_mobile/product/state/base_cubit.dart';

class EmailVerificationCubit extends BaseCubit<EmailVerificationState> {
  EmailVerificationCubit({required this._authRepository})
    : super(const EmailVerificationState());

  final AuthRepository _authRepository;

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    emit(
      const EmailVerificationState(status: EmailVerificationStatus.verifying),
    );
    try {
      await _authRepository.verifyEmail(
        VerifyEmailRequest(email: email, code: code),
      );
      emit(
        const EmailVerificationState(status: EmailVerificationStatus.verified),
      );
    } catch (e) {
      emit(
        EmailVerificationState(
          status: EmailVerificationStatus.verifyFailed,
          errorMessage: e is ApiException
              ? e.toString()
              : AuthErrorMessages.verifyEmailFailed,
        ),
      );
    }
  }

  Future<void> resendCode({required String email}) async {
    emit(EmailVerificationState(status: EmailVerificationStatus.resending));
    try {
      await _authRepository.resendVerificationCode(
        ResendVerificationCodeRequest(email: email),
      );
      emit(
        EmailVerificationState(status: EmailVerificationStatus.resendSuccess),
      );
    } catch (e) {
      emit(
        EmailVerificationState(
          status: EmailVerificationStatus.resendFailed,
          errorMessage: e is ApiException
              ? e.toString()
              : AuthErrorMessages.resendCodeFailed,
        ),
      );
    }
  }
}