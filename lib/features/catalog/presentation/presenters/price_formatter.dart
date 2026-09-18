import 'package:intl/intl.dart';

abstract final class PriceFormatter {
  static final _format = NumberFormat.decimalPatternDigits(
    locale: 'it',
    decimalDigits: 2,
  );

  static String amount(double value) => _format.format(value);
}
