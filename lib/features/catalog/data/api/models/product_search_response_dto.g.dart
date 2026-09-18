// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchResponseDto _$ProductSearchResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ProductSearchResponseDto',
  json,
  ($checkedConvert) {
    final val = ProductSearchResponseDto(
      page: $checkedConvert('page', (v) => (v as num).toInt()),
      groupedHits: $checkedConvert(
        'grouped_hits',
        (v) => (v as List<dynamic>)
            .map((e) => GroupedHitDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'groupedHits': 'grouped_hits'},
);

GroupedHitDto _$GroupedHitDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GroupedHitDto', json, ($checkedConvert) {
      final val = GroupedHitDto(
        hits: $checkedConvert(
          'hits',
          (v) => (v as List<dynamic>)
              .map((e) => HitDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

HitDto _$HitDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HitDto', json, ($checkedConvert) {
      final val = HitDto(
        document: $checkedConvert(
          'document',
          (v) => ProductDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });
