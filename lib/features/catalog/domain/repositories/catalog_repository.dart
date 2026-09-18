import 'package:scalapay_catalog/features/catalog/domain/entities/product_page.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';

abstract interface class CatalogRepository {
  Future<Result<ProductPage>> search(ProductQuery query);
}
