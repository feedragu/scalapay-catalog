import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';

Product named(String title) =>
    Product(id: title, title: title, merchant: 'shop', price: 1);

List<String> titles(Iterable<Product> products) => [
  for (final product in products) product.title,
];

void main() {
  test('server sorts leave the list untouched', () {
    final products = [named('b'), named('a')];
    for (final sort in [
      ProductSort.relevance,
      ProductSort.priceAsc,
      ProductSort.priceDesc,
    ]) {
      expect(sort.isLocal, isFalse);
      expect(sort.apply(products), same(products));
    }
  });

  test('name sorts ignore case and Latin accents', () {
    final products = [
      named('zeta'),
      named('Étoile'),
      named('alpha'),
      named('Über'),
      named('ñandú'),
      named('Beta'),
      named('ècole'),
      named('Alpha'),
    ];

    expect(titles(ProductSort.nameAsc.apply(products)), [
      'Alpha',
      'alpha',
      'Beta',
      'ècole',
      'Étoile',
      'ñandú',
      'Über',
      'zeta',
    ]);
    expect(
      titles(ProductSort.nameDesc.apply(products)),
      titles(ProductSort.nameAsc.apply(products)).reversed,
    );
    expect(titles(products).first, 'zeta', reason: 'input is not mutated');
  });

  test('ß and ligatures fold to their letters', () {
    // "Straße" folds to "strasse", which sorts before "strata" (s < t).
    final products = [
      named('Strata'),
      named('Straße'),
      named('Oz'),
      named('Œuvre'),
    ];
    expect(titles(ProductSort.nameAsc.apply(products)), [
      'Œuvre',
      'Oz',
      'Straße',
      'Strata',
    ]);
  });

  test('equal keys fall back to the raw title, so the order is stable', () {
    final products = [named('nike'), named('Nike'), named('NIKE')];
    expect(titles(ProductSort.nameAsc.apply(products)), [
      'NIKE',
      'Nike',
      'nike',
    ]);
    expect(titles(ProductSort.nameAsc.apply(products.reversed.toList())), [
      'NIKE',
      'Nike',
      'nike',
    ]);
  });
}
