import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/price_input.dart';

void main() {
  double amount(String text) => (PriceInput.parse(text) as PriceAmount).value;

  group('PriceInput.parse', () {
    test('blank means no bound', () {
      expect(PriceInput.parse(''), isA<BlankPrice>());
      expect(PriceInput.parse('   '), isA<BlankPrice>());
    });

    test('accepts integers and up to two decimals with comma or dot', () {
      expect(amount('150'), 150);
      expect(amount(' 150 '), 150);
      expect(amount('0'), 0);
      expect(amount('007'), 7);
      expect(amount('12,5'), 12.5);
      expect(amount('12.5'), 12.5);
      expect(amount('12,99'), 12.99);
      expect(amount('12,'), 12);
      expect(amount(',5'), 0.5);
      expect(amount('9999999'), 9999999);
      expect(amount('9999999,99'), 9999999.99);
    });

    test('rejects anything that is not a plain price', () {
      for (final text in [
        'abc',
        '12abc',
        '1.000',
        '1,000',
        '1.000,50',
        '1,000.50',
        '12,345',
        '12,5,1',
        '12.5.1',
        '-5',
        '+5',
        '1e3',
        '1 000',
        '€10',
        '10€',
        ',',
        '.',
        '12345678',
        '99999999999999999999',
        '１２', // full-width digits
      ]) {
        expect(PriceInput.parse(text), isA<InvalidPrice>(), reason: text);
      }
    });
  });

  group('PriceInput.format', () {
    test('renders applied bounds the way they were typed', () {
      expect(PriceInput.format(null), '');
      expect(PriceInput.format(150), '150');
      expect(PriceInput.format(12.5), '12,50');
      expect(PriceInput.format(12.99), '12,99');
      expect(PriceInput.format(0.5), '0,50');
      expect(PriceInput.format(9999999.99), '9999999,99');
    });

    test('formatted values parse back to the same amount', () {
      for (final value in [0.0, 0.5, 12.5, 12.99, 150.0, 9999999.99]) {
        expect(amount(PriceInput.format(value)), value);
      }
    });
  });

  group('PriceInputFormatter', () {
    const formatter = PriceInputFormatter();

    String type(String text) {
      var value = TextEditingValue.empty;
      for (final char in text.split('')) {
        value = formatter.formatEditUpdate(
          value,
          TextEditingValue(text: value.text + char),
        );
      }
      return value.text;
    }

    String paste(String text) => formatter
        .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text))
        .text;

    test('lets a valid price be typed one character at a time', () {
      expect(type('150'), '150');
      expect(type('12,5'), '12,5');
      expect(type('12.99'), '12.99');
      expect(type(',5'), ',5');
      expect(type('9999999,99'), '9999999,99');
    });

    test('drops the keystrokes that would break the price grammar', () {
      expect(type('25.79,6,64'), '25.79');
      expect(type('12,345'), '12,34');
      expect(type('12345678'), '1234567');
      expect(type('1.000,50'), '1.00');
      expect(type('ab12c'), '12');
      expect(type('-5'), '5');
      expect(type('1 000'), '1000');
    });

    test('rejects an invalid paste as a whole', () {
      expect(paste('1.000,50'), '');
      expect(paste('abc'), '');
      expect(paste('99999999999'), '');
      expect(paste('12,50'), '12,50');
    });
  });
}
