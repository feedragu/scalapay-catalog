import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';

void main() {
  group('PriceRange', () {
    test('no bounds is empty and valid', () {
      expect(PriceRange.none.isEmpty, isTrue);
      expect(PriceRange.none.isValid, isTrue);
    });

    test('single bound is valid', () {
      expect(const PriceRange(min: 10).isValid, isTrue);
      expect(const PriceRange(max: 10).isValid, isTrue);
      expect(const PriceRange(min: 10).isEmpty, isFalse);
    });

    test('min equal to max is valid', () {
      expect(const PriceRange(min: 10, max: 10).isValid, isTrue);
    });

    test('min above max is invalid', () {
      expect(const PriceRange(min: 300, max: 10).isValid, isFalse);
    });

    test('negative bounds are invalid', () {
      expect(const PriceRange(min: -1).isValid, isFalse);
      expect(const PriceRange(max: -5).isValid, isFalse);
    });
  });
}
