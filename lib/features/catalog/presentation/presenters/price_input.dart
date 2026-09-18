import 'package:flutter/services.dart';

// Price typed by the user: up to 7 integer digits, one `,` or `.` separator,
// at most two decimals. Thousands separators are rejected on purpose: "1.000"
// must not become 1.0 silently.
sealed class PriceInput {
  const PriceInput();

  static final _amount = RegExp(r'^(\d{1,7}([.,]\d{0,2})?|[.,]\d{1,2})$');
  static final inputFormatters = [const PriceInputFormatter()];

  static PriceInput parse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const BlankPrice();
    if (!_amount.hasMatch(trimmed)) return const InvalidPrice();
    return PriceAmount(double.parse(trimmed.replaceAll(',', '.')));
  }

  static String format(double? value) {
    if (value == null) return '';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }
}

final class BlankPrice extends PriceInput {
  const BlankPrice();
}

final class PriceAmount extends PriceInput {
  const PriceAmount(this.value);

  final double value;
}

final class InvalidPrice extends PriceInput {
  const InvalidPrice();
}

// Rejects any edit that would not be a (possibly incomplete) price, so a
// second separator or a third decimal cannot even be typed or pasted.
class PriceInputFormatter extends TextInputFormatter {
  const PriceInputFormatter();

  static final _partial = RegExp(r'^\d{0,7}([.,]\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => _partial.hasMatch(newValue.text) ? newValue : oldValue;
}
