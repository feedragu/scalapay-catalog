import 'package:json_annotation/json_annotation.dart';
import 'package:scalapay_catalog/features/catalog/data/api/models/product_dto.dart';

part 'product_search_response_dto.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class ProductSearchResponseDto {
  const ProductSearchResponseDto({
    required this.page,
    required this.groupedHits,
  });

  factory ProductSearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchResponseDtoFromJson(json);

  final int page;
  @JsonKey(name: 'grouped_hits')
  final List<GroupedHitDto> groupedHits;

  List<ProductDto> get products => [
    for (final group in groupedHits)
      for (final hit in group.hits) hit.document,
  ];
}

@JsonSerializable(createToJson: false, checked: true)
class GroupedHitDto {
  const GroupedHitDto({required this.hits});

  factory GroupedHitDto.fromJson(Map<String, dynamic> json) =>
      _$GroupedHitDtoFromJson(json);

  final List<HitDto> hits;
}

@JsonSerializable(createToJson: false, checked: true)
class HitDto {
  const HitDto({required this.document});

  factory HitDto.fromJson(Map<String, dynamic> json) => _$HitDtoFromJson(json);

  final ProductDto document;
}
