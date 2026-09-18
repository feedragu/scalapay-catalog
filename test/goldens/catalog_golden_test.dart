import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_catalog_repository.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/pump_catalog.dart';

// Figma frame "Product catalog - results" and its two bottom sheets, at the
// design viewport (375x812). Baselines were reviewed against the Figma file.
void main() {
  late FakeCatalogRepository repository;

  setUpAll(loadPoppins);

  setUp(() {
    repository = FakeCatalogRepository()
      ..respondWith([
        product(imageUrl: 'https://img.test/shoe_1.png'),
        product(
          id: '2',
          title: 'Nike - Court Vision Low Next Nature Sneakers',
          price: 79.99,
          imageUrl: 'https://img.test/shoe_2.png',
        ),
        product(
          id: '3',
          title: 'Nike - React Vision',
          price: 109.99,
          imageUrl: 'https://img.test/shoe_3.png',
        ),
        product(
          id: '4',
          title: 'Nike - ZoomX Vaporfly',
          price: 229.99,
          imageUrl: 'https://img.test/shoe_4.png',
        ),
      ]);
  });

  // The Figma frames include the 44px iOS status bar.
  Future<void> pumpResults(WidgetTester tester) async {
    await tester.pumpCatalog(
      repository,
      padding: const EdgeInsets.only(top: 44),
    );
    await tester.enterText(find.byType(TextField), 'Nike');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.decodeImages();
  }

  testWidgets('catalog results', (tester) async {
    await pumpResults(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('catalog_results.png'),
    );
  });

  testWidgets('filter sheet', (tester) async {
    await pumpResults(tester);
    await tester.tap(find.text(l10nIt.filtersChip));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), '150');
    await tester.enterText(find.byType(TextField).at(2), '2000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('filter_sheet.png'),
    );
  });

  testWidgets('sort sheet', (tester) async {
    await pumpResults(tester);
    await tester.tap(find.text(l10nIt.sortChip));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10nIt.sortPriceAsc));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10nIt.sortChip));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('sort_sheet.png'),
    );
  });
}
