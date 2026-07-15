import 'package:json_annotation/json_annotation.dart';

part 'success_response.g.dart';

@JsonSerializable(createToJson: false)
class SuccessResponse {
  SuccessResponse({required this.success});

  final bool success;

  factory SuccessResponse.fromJson(Map<String,dynamic> json)=>
      _$SuccessResponseFromJson(json);
}
