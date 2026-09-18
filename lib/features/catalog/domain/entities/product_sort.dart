import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';

enum ProductSort {
  relevance,
  priceAsc,
  priceDesc,
  nameAsc,
  nameDesc;

  // The catalog API only sorts by relevance and price. Name sorts are
  // requested anyway (title:asc/desc) but, until the backend honours them,
  // the domain applies them locally on the widest window the API returns.
  bool get isLocal => this == nameAsc || this == nameDesc;

  List<Product> apply(List<Product> products) {
    if (!isLocal) return products;
    final sorted = [...products]..sort(_byTitle);
    return this == nameAsc ? sorted : sorted.reversed.toList();
  }

  static int _byTitle(Product a, Product b) =>
      a.title.toLowerCase().compareTo(b.title.toLowerCase());
}
