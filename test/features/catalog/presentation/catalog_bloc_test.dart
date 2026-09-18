import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';
import 'package:scalapay_catalog/features/catalog/presentation/bloc/catalog_bloc.dart';

import '../../../helpers/fake_catalog_repository.dart';
import '../../../helpers/fixtures.dart';

void main() {
  const debounce = Duration(milliseconds: 50);
  const afterDebounce = Duration(milliseconds: 120);
  const nike = ProductQuery(text: 'nike');
  final page = products(3);

  late FakeCatalogRepository repository;

  CatalogBloc build() =>
      CatalogBloc(SearchProductsUseCase(repository), searchDebounce: debounce);

  setUp(() {
    repository = FakeCatalogRepository();
  });

  group('search', () {
    blocTest<CatalogBloc, CatalogState>(
      'submitting goes loading then success',
      build: build,
      setUp: () => repository.respondWith(page, hasMore: true),
      act: (bloc) => bloc.add(const CatalogSearchSubmitted('nike')),
      expect: () => [
        const CatalogState(status: CatalogStatus.loading, query: nike),
        CatalogState(
          status: CatalogStatus.success,
          query: nike,
          products: page,
          hasMore: true,
        ),
      ],
      verify: (_) => expect(repository.queries, [nike]),
    );

    blocTest<CatalogBloc, CatalogState>(
      'an empty result is a success with no products',
      build: build,
      act: (bloc) => bloc.add(const CatalogSearchSubmitted('zzz')),
      expect: () => const [
        CatalogState(
          status: CatalogStatus.loading,
          query: ProductQuery(text: 'zzz'),
        ),
        CatalogState(
          status: CatalogStatus.success,
          query: ProductQuery(text: 'zzz'),
        ),
      ],
      verify: (bloc) => expect(bloc.state.isEmpty, isTrue),
    );

    blocTest<CatalogBloc, CatalogState>(
      'submitting blank text returns to the initial state without a request',
      build: build,
      seed: () => CatalogState(
        status: CatalogStatus.success,
        query: nike,
        products: page,
      ),
      act: (bloc) => bloc.add(const CatalogSearchSubmitted('   ')),
      expect: () => const [CatalogState()],
      verify: (_) => expect(repository.queries, isEmpty),
    );

    blocTest<CatalogBloc, CatalogState>(
      'typing shows loading at once and is debounced into a single request',
      build: build,
      setUp: () => repository.respondWith(page),
      act: (bloc) => bloc
        ..add(const CatalogSearchChanged('n'))
        ..add(const CatalogSearchChanged('ni'))
        ..add(const CatalogSearchChanged('nike')),
      wait: afterDebounce,
      expect: () => [
        const CatalogState(
          status: CatalogStatus.loading,
          query: ProductQuery(text: 'n'),
        ),
        const CatalogState(
          status: CatalogStatus.loading,
          query: ProductQuery(text: 'ni'),
        ),
        const CatalogState(status: CatalogStatus.loading, query: nike),
        CatalogState(
          status: CatalogStatus.success,
          query: nike,
          products: page,
        ),
      ],
      verify: (_) => expect(repository.queries, [nike]),
    );

    blocTest<CatalogBloc, CatalogState>(
      'no request is sent before the typing pause',
      build: build,
      act: (bloc) => bloc.add(const CatalogSearchChanged('nike')),
      expect: () => const [
        CatalogState(status: CatalogStatus.loading, query: nike),
      ],
      verify: (_) => expect(repository.queries, isEmpty),
    );

    blocTest<CatalogBloc, CatalogState>(
      'clearing the text returns to idle at once, keeping sort and filters',
      build: build,
      seed: () => CatalogState(
        status: CatalogStatus.success,
        query: nike.copyWith(sort: ProductSort.priceAsc),
        products: page,
      ),
      act: (bloc) => bloc.add(const CatalogSearchChanged('')),
      expect: () => const [
        CatalogState(query: ProductQuery(sort: ProductSort.priceAsc)),
      ],
      verify: (_) => expect(repository.queries, isEmpty),
    );

    blocTest<CatalogBloc, CatalogState>(
      'a sort change during the typing pause searches the typed text once',
      build: build,
      setUp: () => repository.respondWith(page),
      act: (bloc) => bloc
        ..add(const CatalogSearchChanged('nike'))
        ..add(const CatalogSortChanged(ProductSort.priceAsc)),
      wait: afterDebounce,
      verify: (_) => expect(repository.queries, [
        nike.copyWith(sort: ProductSort.priceAsc),
      ]),
    );

    blocTest<CatalogBloc, CatalogState>(
      'submitting during the debounce does not duplicate the request',
      build: build,
      setUp: () => repository.respondWith(page),
      act: (bloc) => bloc
        ..add(const CatalogSearchChanged('nike'))
        ..add(const CatalogSearchSubmitted('nike')),
      wait: afterDebounce,
      expect: () => [
        const CatalogState(status: CatalogStatus.loading, query: nike),
        CatalogState(
          status: CatalogStatus.success,
          query: nike,
          products: page,
        ),
      ],
      verify: (_) => expect(repository.queries, [nike]),
    );

    blocTest<CatalogBloc, CatalogState>(
      'submitting the same text twice sends one request',
      build: build,
      setUp: () => repository.respondWith(page),
      act: (bloc) => bloc
        ..add(const CatalogSearchSubmitted('nike'))
        ..add(const CatalogSearchSubmitted('nike')),
      verify: (_) => expect(repository.queries, [nike]),
    );
  });

  group('failure', () {
    blocTest<CatalogBloc, CatalogState>(
      'a failed request exposes the error and retry recovers',
      build: build,
      setUp: () => repository.failWith(const NetworkUnavailableError()),
      act: (bloc) async {
        bloc.add(const CatalogSearchSubmitted('nike'));
        await Future<void>.delayed(Duration.zero);
        repository.respondWith(page);
        bloc.add(const CatalogRetryRequested());
      },
      expect: () => [
        const CatalogState(status: CatalogStatus.loading, query: nike),
        const CatalogState(
          status: CatalogStatus.failure,
          query: nike,
          error: NetworkUnavailableError(),
        ),
        const CatalogState(status: CatalogStatus.loading, query: nike),
        CatalogState(
          status: CatalogStatus.success,
          query: nike,
          products: page,
        ),
      ],
      verify: (_) => expect(repository.queries, [nike, nike]),
    );

    blocTest<CatalogBloc, CatalogState>(
      'resubmitting the same text after a failure retries',
      build: build,
      setUp: () => repository.failWith(const TimeoutError()),
      seed: () => const CatalogState(
        status: CatalogStatus.failure,
        query: nike,
        error: TimeoutError(),
      ),
      act: (bloc) => bloc.add(const CatalogSearchSubmitted('nike')),
      expect: () => const [
        CatalogState(status: CatalogStatus.loading, query: nike),
        CatalogState(
          status: CatalogStatus.failure,
          query: nike,
          error: TimeoutError(),
        ),
      ],
    );
  });

  group('sort and filters', () {
    blocTest<CatalogBloc, CatalogState>(
      'changing the sort reloads the first page with the new sort',
      build: build,
      setUp: () => repository.respondWith(page),
      seed: () => CatalogState(
        status: CatalogStatus.success,
        query: nike.copyWith(page: 3),
        products: page,
      ),
      act: (bloc) => bloc.add(const CatalogSortChanged(ProductSort.priceDesc)),
      expect: () => [
        CatalogState(
          status: CatalogStatus.loading,
          query: nike.copyWith(sort: ProductSort.priceDesc),
        ),
        CatalogState(
          status: CatalogStatus.success,
          query: nike.copyWith(sort: ProductSort.priceDesc),
          products: page,
        ),
      ],
      verify: (_) => expect(
        repository.queries.single,
        nike.copyWith(sort: ProductSort.priceDesc),
      ),
    );

    blocTest<CatalogBloc, CatalogState>(
      'a name sort is requested, applied locally and closes pagination',
      build: build,
      setUp: () => repository.respondWith([
        product(title: 'zaino'),
        product(id: '2', title: 'Adidas'),
      ], hasMore: true),
      seed: () =>
          const CatalogState(status: CatalogStatus.success, query: nike),
      act: (bloc) => bloc.add(const CatalogSortChanged(ProductSort.nameAsc)),
      verify: (bloc) {
        expect(bloc.state.products.map((p) => p.title), ['Adidas', 'zaino']);
        expect(bloc.state.hasMore, isFalse);
        expect(repository.queries.single.sort, ProductSort.nameAsc);
      },
    );

    blocTest<CatalogBloc, CatalogState>(
      'selecting the current sort does nothing',
      build: build,
      seed: () =>
          const CatalogState(status: CatalogStatus.success, query: nike),
      act: (bloc) => bloc.add(const CatalogSortChanged(ProductSort.relevance)),
      expect: () => const <CatalogState>[],
      verify: (_) => expect(repository.queries, isEmpty),
    );

    blocTest<CatalogBloc, CatalogState>(
      'applying a price range reloads with the range',
      build: build,
      setUp: () => repository.respondWith(page),
      seed: () =>
          const CatalogState(status: CatalogStatus.success, query: nike),
      act: (bloc) =>
          bloc.add(const CatalogFiltersApplied(PriceRange(min: 13, max: 278))),
      expect: () => [
        CatalogState(
          status: CatalogStatus.loading,
          query: nike.copyWith(priceRange: const PriceRange(min: 13, max: 278)),
        ),
        CatalogState(
          status: CatalogStatus.success,
          query: nike.copyWith(priceRange: const PriceRange(min: 13, max: 278)),
          products: page,
        ),
      ],
      verify: (_) => expect(
        repository.queries.single.priceRange,
        const PriceRange(min: 13, max: 278),
      ),
    );

    blocTest<CatalogBloc, CatalogState>(
      'an invalid price range is rejected without a request',
      build: build,
      seed: () =>
          const CatalogState(status: CatalogStatus.success, query: nike),
      act: (bloc) =>
          bloc.add(const CatalogFiltersApplied(PriceRange(min: 300, max: 10))),
      expect: () => const <CatalogState>[],
      verify: (_) => expect(repository.queries, isEmpty),
    );

    blocTest<CatalogBloc, CatalogState>(
      'sort and filters chosen before searching are kept for the search',
      build: build,
      setUp: () => repository.respondWith(page),
      act: (bloc) => bloc
        ..add(const CatalogSortChanged(ProductSort.priceAsc))
        ..add(const CatalogFiltersApplied(PriceRange(max: 50)))
        ..add(const CatalogSearchSubmitted('nike')),
      verify: (_) => expect(
        repository.queries.single,
        const ProductQuery(
          text: 'nike',
          sort: ProductSort.priceAsc,
          priceRange: PriceRange(max: 50),
        ),
      ),
    );
  });

  group('latest request wins', () {
    blocTest<CatalogBloc, CatalogState>(
      'a slow older response never overwrites a newer one',
      build: build,
      act: (bloc) async {
        final pending = repository.pending();
        bloc.add(const CatalogSearchSubmitted('a'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const CatalogSearchSubmitted('b'));
        await Future<void>.delayed(Duration.zero);
        pending[1].complete(
          Success(ProductPage(products: products(2), page: 1, hasMore: false)),
        );
        await Future<void>.delayed(Duration.zero);
        pending[0].complete(
          Success(ProductPage(products: products(9), page: 1, hasMore: true)),
        );
      },
      expect: () => [
        const CatalogState(
          status: CatalogStatus.loading,
          query: ProductQuery(text: 'a'),
        ),
        const CatalogState(
          status: CatalogStatus.loading,
          query: ProductQuery(text: 'b'),
        ),
        CatalogState(
          status: CatalogStatus.success,
          query: const ProductQuery(text: 'b'),
          products: products(2),
        ),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'a stale failure is ignored too',
      build: build,
      act: (bloc) async {
        final pending = repository.pending();
        bloc.add(const CatalogSearchSubmitted('a'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const CatalogSortChanged(ProductSort.priceAsc));
        await Future<void>.delayed(Duration.zero);
        pending[1].complete(
          Success(ProductPage(products: page, page: 1, hasMore: false)),
        );
        await Future<void>.delayed(Duration.zero);
        pending[0].complete(const Failure(TimeoutError()));
      },
      verify: (bloc) {
        expect(bloc.state.status, CatalogStatus.success);
        expect(bloc.state.error, isNull);
        expect(bloc.state.query.sort, ProductSort.priceAsc);
      },
    );
  });

  group('pagination', () {
    final loaded = CatalogState(
      status: CatalogStatus.success,
      query: nike,
      products: products(30),
      hasMore: true,
    );

    blocTest<CatalogBloc, CatalogState>(
      'the next page is appended and the query page advances',
      build: build,
      setUp: () => repository.respondWith(products(5, startId: 31)),
      seed: () => loaded,
      act: (bloc) => bloc.add(const CatalogNextPageRequested()),
      expect: () => [
        loaded.copyWith(isLoadingMore: true),
        loaded.copyWith(
          query: nike.copyWith(page: 2),
          products: products(35),
          hasMore: false,
        ),
      ],
      verify: (_) => expect(repository.queries.single.page, 2),
    );

    blocTest<CatalogBloc, CatalogState>(
      'no request is made when there are no more pages or one is in flight',
      build: build,
      seed: () => loaded.copyWith(hasMore: false),
      act: (bloc) => bloc
        ..add(const CatalogNextPageRequested())
        ..add(const CatalogNextPageRequested()),
      expect: () => const <CatalogState>[],
      verify: (_) => expect(repository.queries, isEmpty),
    );

    blocTest<CatalogBloc, CatalogState>(
      'a page repeating already loaded ids appends nothing',
      build: build,
      setUp: () => repository.respondWith(products(3), hasMore: true),
      seed: () => CatalogState(
        status: CatalogStatus.success,
        query: nike,
        products: products(3),
        hasMore: true,
      ),
      act: (bloc) => bloc.add(const CatalogNextPageRequested()),
      verify: (bloc) {
        expect(bloc.state.products, hasLength(3));
        expect(bloc.state.query.page, 2);
      },
    );

    blocTest<CatalogBloc, CatalogState>(
      'a failed next page keeps the loaded products and flags the failure',
      build: build,
      setUp: () => repository.failWith(const ServerError(500)),
      seed: () => loaded,
      act: (bloc) => bloc.add(const CatalogNextPageRequested()),
      expect: () => [
        loaded.copyWith(isLoadingMore: true),
        loaded.copyWith(loadMoreFailed: true),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'a new search discards a pending next page',
      build: build,
      seed: () => loaded,
      act: (bloc) async {
        final pending = repository.pending();
        bloc.add(const CatalogNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const CatalogSearchSubmitted('adidas'));
        await Future<void>.delayed(Duration.zero);
        pending[1].complete(
          Success(ProductPage(products: products(2), page: 1, hasMore: false)),
        );
        await Future<void>.delayed(Duration.zero);
        pending[0].complete(
          Success(
            ProductPage(
              products: products(30, startId: 31),
              page: 2,
              hasMore: true,
            ),
          ),
        );
      },
      verify: (bloc) {
        expect(bloc.state.query.text, 'adidas');
        expect(bloc.state.products, products(2));
        expect(bloc.state.isLoadingMore, isFalse);
      },
    );
  });
}
