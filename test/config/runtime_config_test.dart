import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/config/runtime_config.dart';

void main() {
  test('reads trimmed values and rejects blank or missing keys', () {
    dotenv.loadFromString(
      envString: 'APP_ENV=dev\nCATALOG_SOURCE= trovaprezzi \nEMPTY=',
    );

    expect(RuntimeConfig.requiredValue('CATALOG_SOURCE'), 'trovaprezzi');
    expect(() => RuntimeConfig.requiredValue('EMPTY'), throwsStateError);
    expect(() => RuntimeConfig.requiredValue('MISSING'), throwsStateError);
  });

  test('the bundled dev file declares every key the app reads', () {
    dotenv.loadFromString(envString: File('.env.dev').readAsStringSync());

    for (final key in [
      'APP_ENV',
      'CATALOG_API_BASE_URL',
      'CATALOG_PARTNER_ID',
      'CATALOG_SOURCE',
      'CATALOG_LANGUAGE',
      'CATALOG_COUNTRY',
    ]) {
      expect(RuntimeConfig.requiredValue(key), isNotEmpty, reason: key);
    }
    expect(
      RuntimeConfig.requiredValue('APP_ENV'),
      RuntimeConfig.selectedEnvironment,
    );
  });
}
