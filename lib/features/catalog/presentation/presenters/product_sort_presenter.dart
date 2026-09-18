import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

typedef SortOption = ({ProductSort sort, String label});

abstract final class ProductSortPresenter {
  // Null for relevance, which has no option in the sheet.
  static String? label(ProductSort sort, AppLocalizations l10n) =>
      switch (sort) {
        ProductSort.relevance => null,
        ProductSort.priceAsc => l10n.sortPriceAsc,
        ProductSort.priceDesc => l10n.sortPriceDesc,
        ProductSort.nameAsc => l10n.sortNameAsc,
        ProductSort.nameDesc => l10n.sortNameDesc,
      };

  static List<SortOption> options(AppLocalizations l10n) => [
    (sort: ProductSort.priceAsc, label: l10n.sortPriceAsc),
    (sort: ProductSort.priceDesc, label: l10n.sortPriceDesc),
    (sort: ProductSort.nameAsc, label: l10n.sortNameAsc),
    (sort: ProductSort.nameDesc, label: l10n.sortNameDesc),
  ];
}
