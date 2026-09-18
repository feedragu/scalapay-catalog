// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ProductDto',
  json,
  ($checkedConvert) {
    final val = ProductDto(
      id: $checkedConvert('id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String),
      merchant: $checkedConvert('merchant', (v) => v as String),
      sellingPrice: $checkedConvert(
        'selling_price',
        (v) => (v as num).toDouble(),
      ),
      image: $checkedConvert('image', (v) => v as String?),
      hasImage: $checkedConvert('has_image', (v) => (v as num?)?.toInt() ?? 0),
    );
    return val;
  },
  fieldKeyMap: const {'sellingPrice': 'selling_price', 'hasImage': 'has_image'},
);
