import 'package:equatable/equatable.dart';

// Scalapay's "pay in 3", shown on every card in the design. The catalog API
// returns no installment data (verified on the response: only prices), so
// the split is computed here from the selling price. A real schedule
// (cent remainder on the first installment, eligibility) belongs to the
// pricing backend and would replace this.
class InstallmentPlan extends Equatable {
  const InstallmentPlan(this.count);

  static const payInThree = InstallmentPlan(3);

  final int count;

  double amountFor(double price) => price / count;

  @override
  List<Object?> get props => [count];
}
