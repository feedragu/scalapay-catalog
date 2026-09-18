import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/catalog_error_presenter.dart';

import '../../../helpers/pump_app.dart';

void main() {
  test('every error has its own localized message', () {
    final messages = [
      const NetworkUnavailableError(),
      const TimeoutError(),
      const ServerError(500),
      const InvalidResponseError(),
      UnknownError(StateError('boom')),
    ].map((error) => CatalogErrorPresenter.message(l10nIt, error)).toList();

    expect(messages.every((m) => m.isNotEmpty), isTrue);
    expect(messages.toSet(), hasLength(messages.length));
  });
}
