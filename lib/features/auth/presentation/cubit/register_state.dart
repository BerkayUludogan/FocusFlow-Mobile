import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
  });

  final RegisterStatus status;
  final String? errorMessage;

  bool get isLoading => status == RegisterStatus.loading;
  bool get isSuccess => status == RegisterStatus.success;

  @override
  List<Object?> get props => [status, errorMessage];
}
