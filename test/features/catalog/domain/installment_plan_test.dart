import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/installment_plan.dart';

void main() {
  test('pay in three splits the selling price in three equal parts', () {
    const plan = InstallmentPlan.payInThree;
    expect(plan.count, 3);
    expect(plan.amountFor(79.99), closeTo(26.663, 0.001));
    expect(plan.amountFor(85), closeTo(28.333, 0.001));
  });
}
