import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

abstract final class CatalogErrorPresenter {
  static String message(AppLocalizations l10n, CatalogError error) {
    return switch (error) {
      NetworkUnavailableError() => l10n.errorNetwork,
      TimeoutError() => l10n.errorTimeout,
      ServerError() => l10n.errorServer,
      InvalidResponseError() => l10n.errorInvalidResponse,
      UnknownError() => l10n.errorUnknown,
    };
  }
}
