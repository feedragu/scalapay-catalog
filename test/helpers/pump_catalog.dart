import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';
import 'package:scalapay_catalog/features/catalog/presentation/pages/catalog_page.dart';

import 'fake_cache_manager.dart';
import 'fake_catalog_repository.dart';
import 'pump_app.dart';

const searchDebounce = Duration(milliseconds: 500);

extension PumpCatalog on WidgetTester {
  Future<void> pumpCatalog(
    FakeCatalogRepository repository, {
    Size size = phoneFigma,
    double textScale = 1,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return pumpApp(
      MultiProvider(
        providers: [
          Provider<SearchProductsUseCase>.value(
            value: SearchProductsUseCase(repository),
          ),
          Provider<BaseCacheManager>.value(
            value: FakeCacheManager(FakeCacheManager.shoes()),
          ),
        ],
        child: const CatalogPage(),
      ),
      size: size,
      textScale: textScale,
      padding: padding,
    );
  }

  // Submits immediately, then lets the debounce timer of the typed text
  // expire so no timer outlives the test.
  Future<void> search(String text) async {
    await enterText(find.byType(TextField).first, text);
    await testTextInput.receiveAction(TextInputAction.search);
    await pumpAndSettle();
    await pump(searchDebounce);
    await pumpAndSettle();
  }
}
