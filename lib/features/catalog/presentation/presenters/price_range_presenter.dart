import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/price_formatter.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

abstract final class PriceRangePresenter {
  // Spoken description of an applied range; null when nothing is applied.
  static String? describe(PriceRange range, AppLocalizations l10n) {
    final min = range.min;
    final max = range.max;
    if (min != null && max != null) {
      return l10n.priceBetween(
        PriceFormatter.amount(min),
        PriceFormatter.amount(max),
      );
    }
    if (min != null) return l10n.priceFrom(PriceFormatter.amount(min));
    if (max != null) return l10n.priceUpTo(PriceFormatter.amount(max));
    return null;
  }
}
