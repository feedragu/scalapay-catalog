import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_api.dart';
import 'package:scalapay_catalog/features/catalog/data/catalog_repository_impl.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/fixtures.dart';

void main() {
  const query = ProductQuery(text: 'nike');

  CatalogRepositoryImpl repository(HttpClientAdapter adapter) =>
      CatalogRepositoryImpl(CatalogApi(fakeDio(adapter)), testApiConfig);

  Map<String, dynamic> pageOf(int count) => {
    'page': 1,
    'found': count,
    'grouped_hits': [
      for (var i = 0; i < count; i++)
        {
          'hits': [
            {
              'document': {
                'id': '$i',
                'title': 'Product $i',
                'merchant': 'Shop',
                'selling_price': 10 + i,
                'list_price': 0,
                'image': 'https://img/$i.jpg',
                'has_image': 1,
              },
            },
          ],
        },
    ],
  };

  ProductPage pageOfResult(Result<ProductPage> result) =>
      (result as Success<ProductPage>).value;

  group('CatalogRepositoryImpl.search', () {
    test('sends the typed request to the search endpoint', () async {
      final adapter = FakeHttpAdapter.json(fixtureJson('search_nike.json'));

      await repository(
        adapter,
      ).search(const ProductQuery(text: 'nike', page: 2));

      final sent = adapter.requests.single;
      expect(sent.method, 'GET');
      expect(sent.uri.host, 'catalog.test');
      expect(sent.uri.path, '/v1/products/search');
      expect(sent.uri.queryParameters['q'], 'nike');
      expect(sent.uri.queryParameters['page'], '2');
      expect(sent.uri.queryParameters['partnerId'], 'partner-test');
      expect(sent.uri.query, contains('sort_by=_text_match%3Adesc'));
    });

    test('maps a real response into domain products', () async {
      final page = pageOfResult(
        await repository(
          FakeHttpAdapter.json(fixtureJson('search_nike.json')),
        ).search(query),
      );

      expect(page.page, 1);
      expect(page.hasMore, isFalse);
      expect(page.products, hasLength(3));
      expect(page.products.first.title, startsWith('Nike Air Force 1'));
      expect(page.products.first.price, 99);
      expect(page.products.first.merchant, 'Madonnina Resell');
      expect(page.products.first.imageUrl, contains('954308021.jpg'));
    });

    test('drops the image when the API flags it as missing', () async {
      Map<String, dynamic> withImage(Object? image, int hasImage) => {
        'page': 1,
        'grouped_hits': [
          {
            'hits': [
              {
                'document': {
                  'id': '1',
                  'title': 'T',
                  'merchant': 'M',
                  'selling_price': 1,
                  'image': image,
                  'has_image': hasImage,
                },
              },
            ],
          },
        ],
      };

      for (final body in [
        withImage('https://img/1.jpg', 0),
        withImage('', 1),
        withImage(null, 1),
      ]) {
        final page = pageOfResult(
          await repository(FakeHttpAdapter.json(body)).search(query),
        );
        expect(page.products.single.imageUrl, isNull);
      }
    });

    test('returns an empty page without more results', () async {
      final page = pageOfResult(
        await repository(FakeHttpAdapter.json(pageOf(0))).search(query),
      );

      expect(page.products, isEmpty);
      expect(page.hasMore, isFalse);
    });

    test('reports more pages only when a full page is returned', () async {
      final full = pageOfResult(
        await repository(FakeHttpAdapter.json(pageOf(30))).search(query),
      );
      final partial = pageOfResult(
        await repository(FakeHttpAdapter.json(pageOf(29))).search(query),
      );
      // A group can carry more than one hit, so a page may exceed per_page.
      final overfull = pageOfResult(
        await repository(FakeHttpAdapter.json(pageOf(31))).search(query),
      );

      expect(full.hasMore, isTrue);
      expect(partial.hasMore, isFalse);
      expect(overfull.hasMore, isTrue);
    });

    test('stops at the 300-result window the API serves', () async {
      final page9 = pageOfResult(
        await repository(
          FakeHttpAdapter.json(pageOf(30)),
        ).search(query.copyWith(page: 9)),
      );
      final page10 = pageOfResult(
        await repository(
          FakeHttpAdapter.json(pageOf(30)),
        ).search(query.copyWith(page: 10)),
      );

      expect(page9.hasMore, isTrue);
      expect(page10.hasMore, isFalse);
    });

    test('returns TimeoutError on a timeout', () async {
      final adapter = FakeHttpAdapter(
        (options) => throw DioException.receiveTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: options,
        ),
      );

      expect(
        await repository(adapter).search(query),
        const Failure<ProductPage>(TimeoutError()),
      );
    });

    test('returns NetworkUnavailableError when offline', () async {
      final adapter = FakeHttpAdapter(
        (options) => throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
          error: socketException(),
        ),
      );

      expect(
        await repository(adapter).search(query),
        const Failure<ProductPage>(NetworkUnavailableError()),
      );
    });

    test('returns ServerError with the HTTP status code', () async {
      final adapter = FakeHttpAdapter.json(
        fixtureJson('error_400.json'),
        statusCode: 400,
      );

      expect(
        await repository(adapter).search(query),
        const Failure<ProductPage>(ServerError(400)),
      );
    });

    test('returns InvalidResponseError on malformed JSON', () async {
      final adapter = FakeHttpAdapter(
        (_) => FakeHttpAdapter.rawResponse('{"page": 1, "grouped_hits": ['),
      );

      expect(
        await repository(adapter).search(query),
        const Failure<ProductPage>(InvalidResponseError()),
      );
    });

    test('returns InvalidResponseError on an unexpected shape', () async {
      final notAnObject = FakeHttpAdapter.json(<Object?>[]);
      final wrongEnvelope = FakeHttpAdapter.json({'hits': <Object?>[]});
      final wrongDocument = FakeHttpAdapter.json({
        'page': 1,
        'grouped_hits': [
          {
            'hits': [
              {
                'document': {'id': 1, 'title': 'price missing'},
              },
            ],
          },
        ],
      });

      for (final adapter in [notAnObject, wrongEnvelope, wrongDocument]) {
        expect(
          await repository(adapter).search(query),
          const Failure<ProductPage>(InvalidResponseError()),
        );
      }
    });
  });
}
