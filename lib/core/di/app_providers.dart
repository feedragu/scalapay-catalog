import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_api.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_api_config.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_dio.dart';
import 'package:scalapay_catalog/features/catalog/data/catalog_repository_impl.dart';
import 'package:scalapay_catalog/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';

List<SingleChildWidget> initProviders(CatalogApiConfig config) {
  return [
    Provider<CatalogApiConfig>.value(value: config),
    Provider<Dio>(
      create: (context) => createCatalogDio(context.read<CatalogApiConfig>()),
      dispose: (_, dio) => dio.close(),
    ),
    Provider<CatalogApi>(create: (context) => CatalogApi(context.read<Dio>())),
    Provider<CatalogRepository>(
      create: (context) => CatalogRepositoryImpl(
        context.read<CatalogApi>(),
        context.read<CatalogApiConfig>(),
      ),
    ),
    Provider<SearchProductsUseCase>(
      create: (context) =>
          SearchProductsUseCase(context.read<CatalogRepository>()),
    ),
    Provider<BaseCacheManager>(create: (_) => DefaultCacheManager()),
  ];
}
