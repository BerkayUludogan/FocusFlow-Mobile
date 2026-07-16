// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedResponse<T> _$PagedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PagedResponse<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);
