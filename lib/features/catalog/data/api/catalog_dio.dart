import 'package:dio/dio.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_api_config.dart';

const catalogConnectTimeout = Duration(seconds: 10);
const catalogReceiveTimeout = Duration(seconds: 30);

Dio createCatalogDio(CatalogApiConfig config) {
  return Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: catalogConnectTimeout,
      receiveTimeout: catalogReceiveTimeout,
    ),
  );
}
