import 'dart:async';

import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';

typedef SearchHandler =
    Future<Result<ProductPage>> Function(ProductQuery query);

class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository([SearchHandler? handler])
    : _handler = handler ?? ((_) async => const Success(emptyPage));

  static const emptyPage = ProductPage(products: [], page: 1, hasMore: false);

  static Result<ProductPage> pageWith(
    List<Product> products, {
    bool hasMore = false,
  }) => Success(ProductPage(products: products, page: 1, hasMore: hasMore));

  SearchHandler _handler;
  final List<ProductQuery> queries = [];

  set handler(SearchHandler handler) => _handler = handler;

  void respondWith(List<Product> products, {bool hasMore = false}) {
    _handler = (query) async => Success(
      ProductPage(products: products, page: query.page, hasMore: hasMore),
    );
  }

  void failWith(CatalogError error) {
    _handler = (_) async => Failure(error);
  }

  // Each call returns a completer keyed by request order so tests can resolve
  // responses out of order.
  List<Completer<Result<ProductPage>>> pending() {
    final completers = <Completer<Result<ProductPage>>>[];
    _handler = (_) {
      final completer = Completer<Result<ProductPage>>();
      completers.add(completer);
      return completer.future;
    };
    return completers;
  }

  @override
  Future<Result<ProductPage>> search(ProductQuery query) {
    queries.add(query);
    return _handler(query);
  }
}
