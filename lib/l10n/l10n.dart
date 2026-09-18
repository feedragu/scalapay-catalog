import 'package:flutter/widgets.dart';
import 'package:scalapay_catalog/l10n/app_localizations.dart';

export 'package:scalapay_catalog/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
