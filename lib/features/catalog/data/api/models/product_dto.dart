import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.merchant,
    required this.sellingPrice,
    this.image,
    this.hasImage = 0,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  final String id;
  final String title;
  final String merchant;
  @JsonKey(name: 'selling_price')
  final double sellingPrice;
  final String? image;
  @JsonKey(name: 'has_image')
  final int hasImage;
}
