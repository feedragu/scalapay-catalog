import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scalapay_catalog/features/catalog/data/api/models/product_search_response_dto.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('ProductSearchResponseDto', () {
    test('parses grouped hits from a real response', () {
      final dto = ProductSearchResponseDto.fromJson(
        fixtureJson('search_nike.json'),
      );

      expect(dto.page, 1);
      expect(dto.products, hasLength(3));
      expect(dto.products.first.id, '954308021');
      expect(dto.products.first.sellingPrice, 99.0);
      expect(dto.products.first.hasImage, 1);
      expect(dto.products[1].sellingPrice, 83.95);
    });

    test('parses an empty result', () {
      final dto = ProductSearchResponseDto.fromJson({
        'page': 1,
        'found': 0,
        'grouped_hits': <Object?>[],
      });
      expect(dto.products, isEmpty);
    });

    test('tolerates a missing has_image flag', () {
      final dto = ProductSearchResponseDto.fromJson({
        'page': 1,
        'grouped_hits': [
          {
            'hits': [
              {
                'document': {
                  'id': '1',
                  'title': 'Minimal',
                  'merchant': 'Shop',
                  'selling_price': 9,
                },
              },
            ],
          },
        ],
      });
      expect(dto.products.single.hasImage, 0);
      expect(dto.products.single.image, isNull);
    });

    test('rejects an envelope without grouped_hits', () {
      expect(
        () => ProductSearchResponseDto.fromJson({'page': 1}),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('rejects a document with a missing required field', () {
      expect(
        () => ProductSearchResponseDto.fromJson({
          'page': 1,
          'grouped_hits': [
            {
              'hits': [
                {
                  'document': {
                    'id': '1',
                    'title': 'No price',
                    'merchant': 'Shop',
                  },
                },
              ],
            },
          ],
        }),
        throwsA(
          isA<CheckedFromJsonException>().having(
            (e) => e.key,
            'key',
            'selling_price',
          ),
        ),
      );
    });
  });
}
