import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scalapay_catalog/core/di/app_providers.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_dio.dart';
import 'package:scalapay_catalog/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';

import '../helpers/fake_http_adapter.dart';

void main() {
  testWidgets('initProviders wires the whole catalog graph', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MultiProvider(
        providers: initProviders(testApiConfig),
        child: Builder(
          builder: (c) {
            context = c;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final dio = context.read<Dio>();
    expect(dio.options.baseUrl, testApiConfig.baseUrl);
    expect(dio.options.connectTimeout, catalogConnectTimeout);
    expect(dio.options.receiveTimeout, catalogReceiveTimeout);
    expect(context.read<CatalogRepository>(), isNotNull);
    expect(context.read<SearchProductsUseCase>(), isNotNull);
    expect(context.read<BaseCacheManager>(), isA<DefaultCacheManager>());
  });
}
