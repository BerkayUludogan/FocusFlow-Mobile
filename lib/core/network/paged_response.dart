import 'package:json_annotation/json_annotation.dart';

part 'paged_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class PagedResponse<T> {
  const PagedResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PagedResponseFromJson(json, fromJsonT);
}
