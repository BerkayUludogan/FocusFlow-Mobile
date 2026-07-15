import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  const RegisterResponse({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAtUtc,
  });

  final String id;
  final String email;
  final String displayName;
  final DateTime createdAtUtc;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}