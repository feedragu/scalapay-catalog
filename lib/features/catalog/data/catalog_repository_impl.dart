import 'package:scalapay_catalog/features/catalog/data/api/catalog_api.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_api_config.dart';
import 'package:scalapay_catalog/features/catalog/data/api/models/product_dto_mapper.dart';
import 'package:scalapay_catalog/features/catalog/data/api/product_search_request.dart';
import 'package:scalapay_catalog/features/catalog/data/catalog_error_mapper.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(
    this._api,
    this._config, [
    this._errorMapper = const CatalogErrorMapper(),
  ]);

  final CatalogApi _api;
  final CatalogApiConfig _config;
  final CatalogErrorMapper _errorMapper;

  @override
  Future<Result<ProductPage>> search(ProductQuery query) async {
    final request = ProductSearchRequest.fromQuery(query, config: _config);
    try {
      final response = await _api.searchProducts(request.toQueryParameters());
      final products = [for (final dto in response.products) dto.toDomain()];
      // `found` mirrors the page size rather than a total, so the only end
      // signal is a page shorter than the requested size.
      return Success(
        ProductPage(
          products: products,
          page: query.page,
          hasMore: products.length >= request.perPage,
        ),
      );
    } catch (error) {
      return Failure(_errorMapper.map(error));
    }
  }
}
