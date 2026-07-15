import 'package:equatable/equatable.dart';

enum EmailVerificationStatus {
  initial,
  verifying,
  verified,
  verifyFailed,
  resending,
  resendSuccess,
  resendFailed,
}

class EmailVerificationState extends Equatable {
  const EmailVerificationState({
    this.status = EmailVerificationStatus.initial,
    this.errorMessage,
  });

  final EmailVerificationStatus status;
  final String? errorMessage;

  bool get isVerifying => status == EmailVerificationStatus.verifying;
  bool get isVerified => status == EmailVerificationStatus.verified;
  bool get isResending => status == EmailVerificationStatus.resending;

  @override
  List<Object?> get props => [status, errorMessage];
}
