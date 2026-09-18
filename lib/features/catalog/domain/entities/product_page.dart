import 'package:equatable/equatable.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';

class ProductPage extends Equatable {
  const ProductPage({
    required this.products,
    required this.page,
    required this.hasMore,
  });

  final List<Product> products;
  final int page;
  final bool hasMore;

  @override
  List<Object?> get props => [products, page, hasMore];
}
