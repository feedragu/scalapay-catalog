import 'package:scalapay_catalog/features/catalog/data/api/models/product_dto.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';

extension ProductDtoMapper on ProductDto {
  Product toDomain() {
    final image = this.image;
    final hasImage = this.hasImage == 1 && image != null && image.isNotEmpty;
    return Product(
      id: id,
      title: title,
      merchant: merchant,
      price: sellingPrice,
      imageUrl: hasImage ? image : null,
    );
  }
}
