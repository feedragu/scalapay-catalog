import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';

class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final CatalogRepository _repository;

  // Sorting a paged list is the server's job. For the sorts the API cannot
  // do (name) the repository fetches its widest window in one request and
  // the order is applied here; that list is complete for the window, so no
  // further pages exist and nothing reshuffles on scroll.
  Future<Result<ProductPage>> call(ProductQuery query) async {
    final result = await _repository.search(query);
    if (!query.sort.isLocal) return result;
    switch (result) {
      case Success():
        final page = result.value;
        return Success(
          ProductPage(
            products: query.sort.apply(page.products),
            page: page.page,
            hasMore: false,
          ),
        );
      case Failure():
        return result;
    }
  }
}
