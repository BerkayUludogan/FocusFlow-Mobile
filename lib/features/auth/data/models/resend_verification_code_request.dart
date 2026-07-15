import 'package:json_annotation/json_annotation.dart';

part 'resend_verification_code_request.g.dart';

@JsonSerializable(createFactory: false)
class ResendVerificationCodeRequest {
  ResendVerificationCodeRequest({required this.email});

  final String email;

  Map<String,dynamic> toJson() => _$ResendVerificationCodeRequestToJson(this);
}
