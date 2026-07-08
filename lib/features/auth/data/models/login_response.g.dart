// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['accessToken'] as String,
      accessTokenExpiresAtUtc: DateTime.parse(
        json['accessTokenExpiresAtUtc'] as String,
      ),
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiresAtUtc: DateTime.parse(
        json['refreshTokenExpiresAtUtc'] as String,
      ),
    );

Map<String, dynamic> _$LoginResponseToJson(
  LoginResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'accessTokenExpiresAtUtc': instance.accessTokenExpiresAtUtc.toIso8601String(),
  'refreshToken': instance.refreshToken,
  'refreshTokenExpiresAtUtc': instance.refreshTokenExpiresAtUtc
      .toIso8601String(),
};
