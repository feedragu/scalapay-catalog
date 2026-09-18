import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/price_range_presenter.dart';

import '../../../helpers/pump_app.dart';

void main() {
  String? describe(PriceRange range) =>
      PriceRangePresenter.describe(range, l10nIt);

  test('describes the applied bounds, or nothing when none is set', () {
    expect(describe(PriceRange.none), isNull);
    expect(describe(const PriceRange(min: 25)), 'Da 25,00 €');
    expect(describe(const PriceRange(max: 50)), 'Fino a 50,00 €');
    expect(
      describe(const PriceRange(min: 25, max: 50)),
      'Da 25,00 € a 50,00 €',
    );
  });
}
