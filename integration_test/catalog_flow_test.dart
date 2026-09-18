import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:scalapay_catalog/app.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';

import '../test/helpers/fake_cache_manager.dart';
import '../test/helpers/fake_catalog_repository.dart';

// Drives the real widget tree on a device with deterministic fake networking.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  List<Product> nike(int count) => [
    for (var i = 1; i <= count; i++)
      Product(
        id: '$i',
        title: 'Nike Air Force 1 $i',
        merchant: 'Pittarello',
        price: 80.0 + i,
      ),
  ];

  Future<void> launch(
    WidgetTester tester,
    FakeCatalogRepository repository,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SearchProductsUseCase>.value(
            value: SearchProductsUseCase(repository),
          ),
          Provider<BaseCacheManager>.value(value: FakeCacheManager()),
        ],
        child: const CatalogApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> search(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField).first, text);
    await tester.tap(find.byTooltip('Cerca'));
    await tester.pumpAndSettle();
  }

  testWidgets('search, sort and filter happy path', (tester) async {
    final repository = FakeCatalogRepository()..respondWith(nike(6));
    await launch(tester, repository);
    expect(find.text('Cerca un prodotto'), findsOneWidget);

    await search(tester, 'nike');
    expect(find.text('Nike Air Force 1 1'), findsOneWidget);
    expect(find.text('3 installments of €27,00'), findsOneWidget);
    expect(repository.queries.single.text, 'nike');

    await tester.tap(find.text('Ordina'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prezzo decrescente'));
    await tester.pumpAndSettle();
    expect(repository.queries.last.sort, ProductSort.priceDesc);
    expect(find.byType(AppProductCard), findsWidgets);

    await tester.tap(find.text('Filtri'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(AppTextField).at(0), '50');
    await tester.enterText(find.byType(AppTextField).at(1), '60');
    await tester.tap(find.text('Mostra risultati'));
    await tester.pumpAndSettle();
    expect(repository.queries.last.priceRange.min, 50);
    expect(repository.queries.last.priceRange.max, 60);
    expect(repository.queries.last.sort, ProductSort.priceDesc);
    expect(find.byType(AppProductCard), findsWidgets);
  });

  testWidgets('error then retry recovers', (tester) async {
    final repository = FakeCatalogRepository()..failWith(const TimeoutError());
    await launch(tester, repository);

    await search(tester, 'nike');
    expect(find.text('Qualcosa è andato storto'), findsOneWidget);
    expect(find.byType(AppProductCard), findsNothing);

    repository.respondWith(nike(2));
    await tester.tap(find.text('Riprova'));
    await tester.pumpAndSettle();
    expect(find.text('Nike Air Force 1 2'), findsOneWidget);
    expect(repository.queries, hasLength(2));
  });
}
