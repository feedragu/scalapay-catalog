import 'package:flutter_dotenv/flutter_dotenv.dart';

// Values live in a bundled asset, so only public client configuration belongs
// here; anything secret must stay behind a backend.
abstract final class RuntimeConfig {
  static const selectedEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static Future<void> load() async {
    await dotenv.load(fileName: '.env.$selectedEnvironment');
    final declared = requiredValue('APP_ENV');
    if (declared != selectedEnvironment) {
      throw StateError(
        'APP_ENV in .env.$selectedEnvironment must equal $selectedEnvironment',
      );
    }
  }

  static String requiredValue(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    if (value.isEmpty) {
      throw StateError('Runtime configuration $key is blank or missing.');
    }
    return value;
  }
}
