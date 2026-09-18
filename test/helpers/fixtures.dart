import 'dart:convert';
import 'dart:io';

import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> fixtureJson(String name) =>
    jsonDecode(fixture(name)) as Map<String, dynamic>;

Product product({
  String id = '1',
  String title = 'Nike - Revolution 6 Next Nature Triple Black',
  String merchant = 'Pittarello',
  double price = 85,
  String? imageUrl,
}) => Product(
  id: id,
  title: title,
  merchant: merchant,
  price: price,
  imageUrl: imageUrl,
);

List<Product> products(int count, {int startId = 1}) => [
  for (var i = 0; i < count; i++)
    product(id: '${startId + i}', title: 'Product ${startId + i}'),
];
