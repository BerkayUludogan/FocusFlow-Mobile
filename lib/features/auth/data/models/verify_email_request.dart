import 'package:json_annotation/json_annotation.dart';

part 'verify_email_request.g.dart';

@JsonSerializable(createFactory: false)
class VerifyEmailRequest {
  VerifyEmailRequest({required this.email, required this.code});

  final String email;
  final String code;

  Map<String,dynamic> toJson() => _$VerifyEmailRequestToJson(this);
}
