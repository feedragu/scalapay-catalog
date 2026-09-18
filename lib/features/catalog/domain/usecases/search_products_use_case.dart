import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';

class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<ProductPage>> call(ProductQuery query) =>
      _repository.search(query);
}
