import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';

import '../../../helpers/fake_catalog_repository.dart';
import '../../../helpers/fixtures.dart';

void main() {
  final unsorted = [
    product(title: 'zaino'),
    product(id: '2', title: 'Adidas'),
    product(id: '3', title: 'nike'),
  ];
  late FakeCatalogRepository repository;
  late SearchProductsUseCase useCase;

  setUp(() {
    repository = FakeCatalogRepository();
    useCase = SearchProductsUseCase(repository);
  });

  test('server-side sorts pass the page through untouched', () async {
    repository.respondWith(unsorted, hasMore: true);
    for (final sort in [
      ProductSort.relevance,
      ProductSort.priceAsc,
      ProductSort.priceDesc,
    ]) {
      final result = await useCase(ProductQuery(text: 'x', sort: sort));
      final page = (result as Success<ProductPage>).value;
      expect(page.products, unsorted);
      expect(page.hasMore, isTrue);
    }
  });

  test(
    'name sorts order the window case-insensitively and end paging',
    () async {
      repository.respondWith(unsorted, hasMore: true);

      final asc = await useCase(
        const ProductQuery(text: 'x', sort: ProductSort.nameAsc),
      );
      final ascPage = (asc as Success<ProductPage>).value;
      expect(ascPage.products.map((p) => p.id), ['2', '3', '1']);
      expect(ascPage.hasMore, isFalse);

      final desc = await useCase(
        const ProductQuery(text: 'x', sort: ProductSort.nameDesc),
      );
      expect((desc as Success<ProductPage>).value.products.map((p) => p.id), [
        '1',
        '3',
        '2',
      ]);
      expect(unsorted.map((p) => p.id), ['1', '2', '3']);
    },
  );

  test('failures are returned as they are', () async {
    repository.failWith(const TimeoutError());
    final result = await useCase(
      const ProductQuery(text: 'x', sort: ProductSort.nameAsc),
    );
    expect(result, const Failure<ProductPage>(TimeoutError()));
  });
}
