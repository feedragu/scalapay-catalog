import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/data/api/product_search_request.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';

import '../../../helpers/fake_http_adapter.dart';

void main() {
  ProductSearchRequest request(ProductQuery query) =>
      ProductSearchRequest.fromQuery(query, config: testApiConfig);

  group('ProductSearchRequest', () {
    test('builds the documented generic search from the config', () {
      expect(request(const ProductQuery(text: 'nike')).toQueryParameters(), {
        'q': 'nike',
        'per_page': '30',
        'page': '1',
        'filter_by': '',
        'sort_by': '_text_match:desc',
        'partnerId': 'partner-test',
        'source': 'source-test',
        'language': 'it',
        'country': 'IT',
      });
    });

    test('maps price sorts to selling_price with a direction', () {
      expect(
        request(const ProductQuery(sort: ProductSort.priceAsc)).sortBy,
        'selling_price:asc',
      );
      expect(
        request(const ProductQuery(sort: ProductSort.priceDesc)).sortBy,
        'selling_price:desc',
      );
    });

    test('name sorts are requested from the server', () {
      expect(
        request(const ProductQuery(sort: ProductSort.nameAsc)).sortBy,
        'title:asc',
      );
      expect(
        request(const ProductQuery(sort: ProductSort.nameDesc)).sortBy,
        'title:desc',
      );
    });

    test('adds minPrice and maxPrice only when set', () {
      final both = request(
        const ProductQuery(priceRange: PriceRange(min: 13, max: 278)),
      ).toQueryParameters();
      expect(both['minPrice'], '13.0');
      expect(both['maxPrice'], '278.0');

      final onlyMax = request(
        const ProductQuery(priceRange: PriceRange(max: 30)),
      ).toQueryParameters();
      expect(onlyMax.containsKey('minPrice'), isFalse);
      expect(onlyMax['maxPrice'], '30.0');
    });

    test('serializes decimal bounds without exponent notation', () {
      final params = request(
        const ProductQuery(priceRange: PriceRange(min: 0.5, max: 9999999.99)),
      ).toQueryParameters();
      expect(params['minPrice'], '0.5');
      expect(params['maxPrice'], '9999999.99');
    });

    test('carries the page and the 30-item page size', () {
      final params = request(const ProductQuery(page: 3)).toQueryParameters();
      expect(params['page'], '3');
      expect(params['per_page'], '30');
    });

    test('locally sorted queries ask for the widest window in one request', () {
      for (final sort in [ProductSort.nameAsc, ProductSort.nameDesc]) {
        final params = request(ProductQuery(sort: sort)).toQueryParameters();
        expect(params['per_page'], '300');
      }
    });

    test('encodes the sort separator and free text as a URL query', () {
      final uri = Uri.https(
        'catalog-api.dev-cat.scalapay.com',
        '/v1/products/search',
        request(
          const ProductQuery(
            text: 't-shirt & "air"',
            sort: ProductSort.priceAsc,
            priceRange: PriceRange(min: 13, max: 278),
          ),
        ).toQueryParameters(),
      );

      expect(uri.query, contains('sort_by=selling_price%3Aasc'));
      expect(uri.query, contains('q=t-shirt+%26+%22air%22'));
      expect(uri.query, contains('minPrice=13.0&maxPrice=278.0'));
    });
  });
}
