import 'package:equatable/equatable.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';

class ProductQuery extends Equatable {
  const ProductQuery({
    this.text = '',
    this.sort = ProductSort.relevance,
    this.priceRange = PriceRange.none,
    this.page = 1,
  });

  final String text;
  final ProductSort sort;
  final PriceRange priceRange;
  final int page;

  ProductQuery copyWith({
    String? text,
    ProductSort? sort,
    PriceRange? priceRange,
    int? page,
  }) {
    return ProductQuery(
      text: text ?? this.text,
      sort: sort ?? this.sort,
      priceRange: priceRange ?? this.priceRange,
      page: page ?? this.page,
    );
  }

  ProductQuery nextPage() => copyWith(page: page + 1);

  @override
  List<Object?> get props => [text, sort, priceRange, page];
}
