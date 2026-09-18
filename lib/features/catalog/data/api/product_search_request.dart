import 'package:scalapay_catalog/features/catalog/data/api/catalog_api_config.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';

class ProductSearchRequest {
  const ProductSearchRequest({
    required this.config,
    required this.text,
    required this.sort,
    required this.priceRange,
    required this.page,
    this.perPage = defaultPerPage,
  });

  // Locally sorted queries ask for the widest window the API serves in one
  // request (verified: per_page is capped at 300) instead of a page.
  factory ProductSearchRequest.fromQuery(
    ProductQuery query, {
    required CatalogApiConfig config,
  }) {
    return ProductSearchRequest(
      config: config,
      text: query.text,
      sort: query.sort,
      priceRange: query.priceRange,
      page: query.page,
      perPage: query.sort.isLocal ? maxWindow : defaultPerPage,
    );
  }

  static const defaultPerPage = 30;
  static const maxWindow = 300;

  final CatalogApiConfig config;
  final String text;
  final ProductSort sort;
  final PriceRange priceRange;
  final int page;
  final int perPage;

  // The gateway allow-lists _text_match and selling_price and silently
  // ignores anything else (verified). Name sorts are still requested as
  // designed, so the local fallback becomes redundant once the backend
  // supports them.
  String get sortBy => switch (sort) {
    ProductSort.relevance => '_text_match:desc',
    ProductSort.priceAsc => 'selling_price:asc',
    ProductSort.priceDesc => 'selling_price:desc',
    ProductSort.nameAsc => 'title:asc',
    ProductSort.nameDesc => 'title:desc',
  };

  Map<String, String> toQueryParameters() {
    final min = priceRange.min;
    final max = priceRange.max;
    return {
      'q': text,
      'per_page': '$perPage',
      'page': '$page',
      'filter_by': '',
      'sort_by': sortBy,
      if (min != null) 'minPrice': '$min',
      if (max != null) 'maxPrice': '$max',
      'partnerId': config.partnerId,
      'source': config.source,
      'language': config.language,
      'country': config.country,
    };
  }
}
