import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';
import 'package:scalapay_catalog/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:scalapay_catalog/features/catalog/presentation/screens/catalog_screen.dart';

import '../../../helpers/fake_catalog_repository.dart';
import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/pump_catalog.dart';

void main() {
  late FakeCatalogRepository repository;

  // Real glyph widths, so wrapping assertions mean what they do on a device.
  setUpAll(loadPoppins);

  setUp(() {
    repository = FakeCatalogRepository();
  });

  group('states', () {
    testWidgets('starts with the search prompt and no request', (tester) async {
      await tester.pumpCatalog(repository);

      expect(find.text(l10nIt.catalogTitle), findsOneWidget);
      expect(find.text(l10nIt.idleTitle), findsOneWidget);
      expect(repository.queries, isEmpty);
    });

    testWidgets('shows skeletons while loading, then the products', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final pending = repository.pending();
      await tester.pumpCatalog(repository);
      await tester.enterText(find.byType(TextField), 'nike');
      await tester.pump();

      // Skeletons appear on the first keystroke, before any request starts.
      expect(find.byType(AppProductCardSkeleton), findsWidgets);
      expect(find.text(l10nIt.idleTitle), findsNothing);
      expect(pending, isEmpty);
      await tester.pump(searchDebounce);

      expect(pending, hasLength(1));
      expect(find.byType(AppShimmer), findsWidgets);
      expect(find.bySemanticsLabel(l10nIt.loadingProducts), findsOneWidget);
      await tester.pump(AppShimmer.duration);
      expect(tester.takeException(), isNull);

      pending.single.complete(
        FakeCatalogRepository.pageWith([
          product(title: 'Nike - Revolution 6'),
          product(id: '2', title: 'Nike - Court Vision', price: 79.99),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppProductCardSkeleton), findsNothing);
      expect(find.text('Nike - Revolution 6'), findsOneWidget);
      expect(find.text('Pittarello'), findsNWidgets(2));
      expect(find.text('85,00€ or'), findsOneWidget);
      expect(find.text('3 installments of €28,33'), findsOneWidget);
      expect(find.text('3 installments of €26,66'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('shows the empty state for no results', (tester) async {
      await tester.pumpCatalog(repository);
      await tester.search('zzz');

      expect(find.text(l10nIt.emptyTitle), findsOneWidget);
      expect(find.byType(AppProductCard), findsNothing);
    });

    testWidgets('shows the error and retry recovers', (tester) async {
      repository.failWith(const NetworkUnavailableError());
      await tester.pumpCatalog(repository);
      await tester.search('nike');

      expect(find.text(l10nIt.errorTitle), findsOneWidget);
      expect(find.text(l10nIt.errorNetwork), findsOneWidget);

      repository.respondWith([product(title: 'Nike - Revolution 6')]);
      await tester.tap(find.text(l10nIt.retry));
      await tester.pumpAndSettle();

      expect(find.text('Nike - Revolution 6'), findsOneWidget);
      expect(repository.queries, hasLength(2));
    });

    testWidgets('clearing the search returns to the prompt', (tester) async {
      repository.respondWith([product()]);
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      expect(find.byType(AppProductCard), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.pump(searchDebounce);
      await tester.pumpAndSettle();

      expect(find.text(l10nIt.idleTitle), findsOneWidget);
      expect(repository.queries, hasLength(1));
    });
  });

  group('search input', () {
    testWidgets('typing is debounced into one request', (tester) async {
      await tester.pumpCatalog(repository);
      await tester.enterText(find.byType(TextField), 'n');
      await tester.enterText(find.byType(TextField), 'ni');
      await tester.enterText(find.byType(TextField), 'nike');
      await tester.pump(const Duration(milliseconds: 100));
      expect(repository.queries, isEmpty);

      await tester.pump(searchDebounce);
      await tester.pumpAndSettle();
      expect(repository.queries.map((q) => q.text), ['nike']);
    });

    testWidgets('the search button submits immediately', (tester) async {
      await tester.pumpCatalog(repository);
      await tester.enterText(find.byType(TextField), 'nike');
      await tester.tap(find.byTooltip(l10nIt.searchAction));
      await tester.pump();

      expect(repository.queries.map((q) => q.text), ['nike']);
      await tester.pump(searchDebounce);
      await tester.pumpAndSettle();
      expect(repository.queries, hasLength(1));
    });

    testWidgets('tapping outside the field dismisses focus', (tester) async {
      await tester.pumpCatalog(repository);
      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(tester.testTextInput.isVisible, isTrue);

      await tester.tapAt(const Offset(187, 600));
      await tester.pump();
      expect(tester.testTextInput.isVisible, isFalse);
      await tester.pump(searchDebounce);
    });
  });

  group('sheets', () {
    testWidgets('sort sheet lists the Figma options and applies one', (
      tester,
    ) async {
      repository.respondWith([product()]);
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      await tester.tap(find.text(l10nIt.sortChip));
      await tester.pumpAndSettle();

      for (final label in [
        l10nIt.sortPriceAsc,
        l10nIt.sortPriceDesc,
        l10nIt.sortNameAsc,
        l10nIt.sortNameDesc,
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      await tester.tap(find.text(l10nIt.sortPriceDesc));
      await tester.pumpAndSettle();

      expect(find.byType(AppSortOptionList), findsNothing);
      expect(repository.queries.last.sort.name, 'priceDesc');

      await tester.tap(find.text(l10nIt.sortChip));
      await tester.pumpAndSettle();
      final selected = tester
          .widgetList<AppRadio>(find.byType(AppRadio))
          .map((radio) => radio.selected)
          .toList();
      expect(selected, [false, true, false, false]);

      await tester.tap(find.text(l10nIt.sortPriceDesc));
      await tester.pumpAndSettle();
      expect(repository.queries.last.sort.name, 'relevance');
    });

    testWidgets('filter sheet keeps a draft until results are requested', (
      tester,
    ) async {
      repository.respondWith([product()]);
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(AppTextField).at(0), '150');
      await tester.tap(find.byTooltip(l10nIt.close));
      await tester.pumpAndSettle();
      expect(repository.queries, hasLength(1));

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      final fields = find.byType(AppTextField);
      await tester.enterText(fields.at(0), '150');
      await tester.enterText(fields.at(1), '2000');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();

      expect(repository.queries.last.priceRange.min, 150);
      expect(repository.queries.last.priceRange.max, 2000);

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      expect(find.text('150'), findsOneWidget);
      expect(find.text('2000'), findsOneWidget);
    });

    testWidgets('filter sheet rejects an inverted or invalid range', (
      tester,
    ) async {
      await tester.pumpCatalog(repository);
      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      final fields = find.byType(AppTextField);

      await tester.enterText(fields.at(0), '300');
      await tester.enterText(fields.at(1), '10');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();
      expect(find.text(l10nIt.invalidPriceRange), findsOneWidget);
      // The message wraps under the half-width field instead of truncating.
      final error = tester.renderObject<RenderParagraph>(
        find.text(l10nIt.invalidPriceRange),
      );
      expect(error.didExceedMaxLines, isFalse);
      expect(find.byType(AppSheetActions), findsOneWidget);

      // A lone separator is the only unreadable text the formatter lets in.
      await tester.enterText(fields.at(1), ',');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();
      expect(find.text(l10nIt.invalidPriceNumber), findsOneWidget);
      expect(repository.queries, isEmpty);
    });

    testWidgets('filter sheet accepts decimals and keeps them on reopen', (
      tester,
    ) async {
      repository.respondWith([product()]);
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      final fields = find.byType(AppTextField);

      await tester.enterText(fields.at(0), '12,5');
      await tester.enterText(fields.at(1), '99.99');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();
      expect(repository.queries.last.priceRange.min, 12.5);
      expect(repository.queries.last.priceRange.max, 99.99);

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      expect(find.text('12,50'), findsOneWidget);
      expect(find.text('99,99'), findsOneWidget);
    });

    testWidgets('filter fields only accept price-shaped text', (tester) async {
      await tester.pumpCatalog(repository);
      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      final fields = find.byType(AppTextField);
      String textOf(int index) => tester
          .widget<TextField>(find.byType(TextField).at(index + 1))
          .controller!
          .text;

      for (final rejected in [
        'ab12c',
        '1.000',
        '1,000.50',
        '25.79,6',
        '12345678',
        '-5',
      ]) {
        await tester.enterText(fields.at(0), rejected);
        expect(textOf(0), '', reason: rejected);
      }
      for (final accepted in ['1234567', '12,5', '12.99', ',5']) {
        await tester.enterText(fields.at(1), accepted);
        expect(textOf(1), accepted);
      }
    });

    testWidgets('a filter and sort chosen before searching drive the first '
        'search and mark the chips', (tester) async {
      repository.respondWith([product()]);
      await tester.pumpCatalog(repository);
      bool activeChip(String label) =>
          tester.widget<AppChip>(find.widgetWithText(AppChip, label)).active;
      expect(activeChip(l10nIt.filtersChip), isFalse);
      expect(activeChip(l10nIt.sortChip), isFalse);

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(AppTextField).at(0), '25');
      await tester.enterText(find.byType(AppTextField).at(1), '50');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10nIt.sortChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10nIt.sortPriceDesc));
      await tester.pumpAndSettle();

      expect(repository.queries, isEmpty);
      expect(find.text(l10nIt.idleTitle), findsOneWidget);
      expect(activeChip(l10nIt.filtersChip), isTrue);
      expect(activeChip(l10nIt.sortChip), isTrue);

      await tester.search('nike');
      final query = repository.queries.single;
      expect(query.text, 'nike');
      expect(query.priceRange, const PriceRange(min: 25, max: 50));
      expect(query.sort, ProductSort.priceDesc);

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10nIt.clearAll));
      await tester.pumpAndSettle();
      expect(activeChip(l10nIt.filtersChip), isFalse);
      expect(repository.queries.last.priceRange, PriceRange.none);
    });

    testWidgets('clear all applies an empty range', (tester) async {
      repository.respondWith([product()]);
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(AppTextField).at(0), '50');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();
      expect(repository.queries.last.priceRange.min, 50);

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10nIt.clearAll));
      await tester.pumpAndSettle();

      expect(repository.queries.last.priceRange.isEmpty, isTrue);
    });
  });

  group('pagination', () {
    CatalogState stateOf(WidgetTester tester) =>
        tester.element(find.byType(CatalogScreen)).read<CatalogBloc>().state;

    // Pumps fixed frames instead of settling: a load-more spinner may be
    // animating when the scroll ends.
    Future<void> scrollToEnd(WidgetTester tester) async {
      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, -6000),
        3000,
      );
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
    }

    testWidgets('scrolling near the end loads the next page', (tester) async {
      repository.handler = (query) async => FakeCatalogRepository.pageWith(
        products(30, startId: (query.page - 1) * 30 + 1),
        hasMore: query.page == 1,
      );
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      await scrollToEnd(tester);

      expect(repository.queries.map((q) => q.page), [1, 2]);
      expect(stateOf(tester).products, hasLength(60));
      expect(stateOf(tester).hasMore, isFalse);
    });

    testWidgets('a failed next page shows an inline retry', (tester) async {
      repository.respondWith(products(30), hasMore: true);
      await tester.pumpCatalog(repository);
      await tester.search('nike');

      final pending = repository.pending();
      await scrollToEnd(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      pending.single.complete(const Failure(ServerError(500)));
      await tester.pumpAndSettle();
      expect(find.text(l10nIt.loadMoreFailed), findsOneWidget);
      expect(stateOf(tester).products, hasLength(30));

      // Scrolling again must not retry by itself; only the button does.
      await scrollToEnd(tester);
      expect(repository.queries, hasLength(2));

      repository.respondWith(products(5, startId: 31));
      tester.widget<AppTextButton>(find.byType(AppTextButton)).onPressed!();
      await tester.pumpAndSettle();
      expect(find.text(l10nIt.loadMoreFailed), findsNothing);
      expect(stateOf(tester).products, hasLength(35));
    });
  });

  group('rendering', () {
    testWidgets('a broken image falls back to the placeholder', (tester) async {
      repository.respondWith([
        product(imageUrl: 'https://img.test/missing.jpg'),
        product(id: '2', imageUrl: 'https://img.test/shoe_1.png'),
        product(id: '3'),
      ]);
      await tester.pumpCatalog(repository);
      await tester.search('nike');

      expect(find.byIcon(Icons.image_not_supported_outlined), findsNWidgets(2));
      expect(find.byType(AppNetworkImage), findsNWidgets(2));
    });

    for (final size in [phoneSmall, phoneMedium, phoneLarge, tablet]) {
      testWidgets('lays out two columns at ${size.width}', (tester) async {
        repository.respondWith(products(4));
        await tester.pumpCatalog(repository, size: size);
        await tester.search('nike');

        final cards = find.byType(AppProductCard, skipOffstage: false);
        final firstRow = tester.getTopLeft(cards.at(1)).dy;
        expect(tester.getTopLeft(cards.first).dy, firstRow);
        expect(tester.getTopLeft(cards.at(2)).dy, greaterThan(firstRow));
        expect(tester.takeException(), isNull);
      });
    }

    for (final scale in [1.3, 2.0]) {
      testWidgets('survives text scale $scale without overflow', (
        tester,
      ) async {
        repository.respondWith(products(4));
        await tester.pumpCatalog(
          repository,
          size: phoneSmall,
          textScale: scale,
        );
        await tester.search('nike');
        expect(find.text('Product 1'), findsOneWidget);

        await tester.tap(find.text(l10nIt.filtersChip));
        await tester.pumpAndSettle();
        expect(find.text(l10nIt.showResults), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('scroll position', () {
    double offsetOf(WidgetTester tester) => tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;

    Future<void> scrollDown(WidgetTester tester) async {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();
      expect(offsetOf(tester), greaterThan(400));
    }

    testWidgets('focusing the search field does not move the list', (
      tester,
    ) async {
      repository.respondWith(products(30));
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      await scrollDown(tester);
      final offset = offsetOf(tester);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isTrue);
      expect(offsetOf(tester), offset);
    });

    testWidgets('a new search restarts from the top, a new page does not', (
      tester,
    ) async {
      repository.handler = (query) async => FakeCatalogRepository.pageWith(
        products(30, startId: (query.page - 1) * 30 + 1),
        hasMore: query.page == 1,
      );
      await tester.pumpCatalog(repository);
      await tester.search('nike');
      await scrollDown(tester);
      final offset = offsetOf(tester);

      // Appending a page keeps the position.
      tester
          .element(find.byType(CatalogScreen))
          .read<CatalogBloc>()
          .add(const CatalogNextPageRequested());
      await tester.pumpAndSettle();
      expect(offsetOf(tester), offset);

      await tester.enterText(find.byType(TextField), 'adidas');
      await tester.pump();
      expect(offsetOf(tester), 0);
      await tester.pump(searchDebounce);
      await tester.pumpAndSettle();
      expect(offsetOf(tester), 0);
    });
  });

  group('semantics', () {
    testWidgets('controls expose labels and roles', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpCatalog(repository);

      expect(
        tester.getSemantics(find.byTooltip(l10nIt.searchAction)),
        isSemantics(
          tooltip: l10nIt.searchAction,
          isButton: true,
          hasTapAction: true,
          isEnabled: true,
        ),
      );
      expect(
        tester.getSemantics(find.byType(AppChip).first),
        isSemantics(
          label: l10nIt.filtersChip,
          isButton: true,
          hasTapAction: true,
        ),
      );

      await tester.tap(find.text(l10nIt.sortChip));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.byType(AppRadioTile).first),
        isSemantics(
          label: l10nIt.sortPriceAsc,
          hasCheckedState: true,
          isChecked: false,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(
          find.descendant(
            of: find.byType(AppSheetHeader),
            matching: find.text(l10nIt.sortTitle),
          ),
        ),
        isSemantics(isHeader: true),
      );
      handle.dispose();
    });

    testWidgets('the search field keeps its name once it has text', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpCatalog(repository);
      final field = find.byType(TextField);

      expect(
        tester.getSemantics(field),
        isSemantics(label: l10nIt.searchHint, isTextField: true),
      );
      await tester.enterText(field, 'nike');
      await tester.pump();
      expect(
        tester.getSemantics(field),
        isSemantics(label: l10nIt.searchHint, value: 'nike', isTextField: true),
      );
      await tester.pump(searchDebounce);
      handle.dispose();
    });

    testWidgets('active chips describe the applied range and sort', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpCatalog(repository);
      await tester.search('nike');

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(1), '25');
      await tester.enterText(find.byType(TextField).at(2), '50');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10nIt.sortChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10nIt.sortPriceDesc));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.widgetWithText(AppChip, l10nIt.filtersChip)),
        isSemantics(
          label: l10nIt.filtersChip,
          value: l10nIt.priceBetween('25,00', '50,00'),
          isSelected: true,
          isButton: true,
        ),
      );
      expect(
        tester.getSemantics(find.widgetWithText(AppChip, l10nIt.sortChip)),
        isSemantics(
          label: l10nIt.sortChip,
          value: l10nIt.sortPriceDesc,
          isSelected: true,
          isButton: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('results and input errors are announced', (tester) async {
      final handle = tester.ensureSemantics();
      repository.respondWith(products(3));
      await tester.pumpCatalog(repository);
      await tester.search('nike');

      expect(
        tester.getSemantics(find.bySemanticsLabel(l10nIt.resultsCount(3))),
        isSemantics(isLiveRegion: true),
      );

      await tester.tap(find.text(l10nIt.filtersChip));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(1), '50');
      await tester.enterText(find.byType(TextField).at(2), '25');
      await tester.tap(find.text(l10nIt.showResults));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.text(l10nIt.invalidPriceRange)),
        isSemantics(isLiveRegion: true),
      );
      handle.dispose();
    });
  });
}
