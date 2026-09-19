import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';

enum ProductSort {
  relevance,
  priceAsc,
  priceDesc,
  nameAsc,
  nameDesc;

  // The catalog API only sorts by relevance and price. Name sorts are applied
  // by the domain on the widest window the API returns for the query.
  bool get isLocal => this == nameAsc || this == nameDesc;

  List<Product> apply(List<Product> products) {
    if (!isLocal) return products;
    final sorted = [...products]..sort(_byTitle);
    return this == nameAsc ? sorted : sorted.reversed.toList();
  }

  // Dart has no locale collation, so the key folds case and the Latin accents
  // that occur in product titles: "Étoile" sorts with the E's, not after "z".
  // Equal keys fall back to the raw title so the order is deterministic.
  static int _byTitle(Product a, Product b) {
    final byKey = _sortKey(a.title).compareTo(_sortKey(b.title));
    return byKey != 0 ? byKey : a.title.compareTo(b.title);
  }

  static String _sortKey(String title) => title
      .toLowerCase()
      .split('')
      .map((char) => _foldedLetters[char] ?? char)
      .join();

  static const _foldedLetters = {
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'å': 'a',
    'æ': 'ae',
    'ç': 'c',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ñ': 'n',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    'ø': 'o',
    'œ': 'oe',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ý': 'y',
    'ÿ': 'y',
    'ß': 'ss',
  };
}
