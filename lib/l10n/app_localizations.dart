import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('it')];

  /// No description provided for @catalogTitle.
  ///
  /// In it, this message translates to:
  /// **'Esplora i prodotti'**
  String get catalogTitle;

  /// No description provided for @searchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca brand o negozi'**
  String get searchHint;

  /// No description provided for @searchAction.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get searchAction;

  /// No description provided for @filtersChip.
  ///
  /// In it, this message translates to:
  /// **'Filtri'**
  String get filtersChip;

  /// No description provided for @sortChip.
  ///
  /// In it, this message translates to:
  /// **'Ordina'**
  String get sortChip;

  /// No description provided for @filtersTitle.
  ///
  /// In it, this message translates to:
  /// **'Filtri'**
  String get filtersTitle;

  /// No description provided for @sortTitle.
  ///
  /// In it, this message translates to:
  /// **'Ordina'**
  String get sortTitle;

  /// No description provided for @close.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get close;

  /// No description provided for @priceRangeTitle.
  ///
  /// In it, this message translates to:
  /// **'Fascia di prezzo'**
  String get priceRangeTitle;

  /// No description provided for @priceMin.
  ///
  /// In it, this message translates to:
  /// **'Minimo'**
  String get priceMin;

  /// No description provided for @priceMax.
  ///
  /// In it, this message translates to:
  /// **'Massimo'**
  String get priceMax;

  /// No description provided for @clearAll.
  ///
  /// In it, this message translates to:
  /// **'Cancella tutto'**
  String get clearAll;

  /// No description provided for @showResults.
  ///
  /// In it, this message translates to:
  /// **'Mostra risultati'**
  String get showResults;

  /// No description provided for @sortPriceAsc.
  ///
  /// In it, this message translates to:
  /// **'Prezzo crescente'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In it, this message translates to:
  /// **'Prezzo decrescente'**
  String get sortPriceDesc;

  /// No description provided for @sortNameAsc.
  ///
  /// In it, this message translates to:
  /// **'Nome A-Z'**
  String get sortNameAsc;

  /// No description provided for @sortNameDesc.
  ///
  /// In it, this message translates to:
  /// **'Nome Z-A'**
  String get sortNameDesc;

  /// No description provided for @fullPrice.
  ///
  /// In it, this message translates to:
  /// **'{amount}€ or'**
  String fullPrice(String amount);

  /// No description provided for @installments.
  ///
  /// In it, this message translates to:
  /// **'{count} installments of €{amount}'**
  String installments(int count, String amount);

  /// No description provided for @idleTitle.
  ///
  /// In it, this message translates to:
  /// **'Cerca un prodotto'**
  String get idleTitle;

  /// No description provided for @idleMessage.
  ///
  /// In it, this message translates to:
  /// **'Scrivi un brand o un negozio per esplorare il catalogo'**
  String get idleMessage;

  /// No description provided for @emptyTitle.
  ///
  /// In it, this message translates to:
  /// **'Nessun risultato'**
  String get emptyTitle;

  /// No description provided for @emptyMessage.
  ///
  /// In it, this message translates to:
  /// **'Prova con un altro termine o modifica i filtri'**
  String get emptyMessage;

  /// No description provided for @errorTitle.
  ///
  /// In it, this message translates to:
  /// **'Qualcosa è andato storto'**
  String get errorTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In it, this message translates to:
  /// **'Controlla la connessione e riprova'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In it, this message translates to:
  /// **'Il catalogo non risponde, riprova tra poco'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In it, this message translates to:
  /// **'Il catalogo non è disponibile al momento'**
  String get errorServer;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In it, this message translates to:
  /// **'Il catalogo ha restituito dati non validi'**
  String get errorInvalidResponse;

  /// No description provided for @errorUnknown.
  ///
  /// In it, this message translates to:
  /// **'Si è verificato un errore inatteso'**
  String get errorUnknown;

  /// No description provided for @retry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get retry;

  /// No description provided for @loadMoreFailed.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare altri prodotti'**
  String get loadMoreFailed;

  /// No description provided for @loadingProducts.
  ///
  /// In it, this message translates to:
  /// **'Caricamento prodotti'**
  String get loadingProducts;

  /// No description provided for @resultsCount.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{1 prodotto trovato} other{{count} prodotti trovati}}'**
  String resultsCount(int count);

  /// No description provided for @priceFrom.
  ///
  /// In it, this message translates to:
  /// **'Da {min} €'**
  String priceFrom(String min);

  /// No description provided for @priceUpTo.
  ///
  /// In it, this message translates to:
  /// **'Fino a {max} €'**
  String priceUpTo(String max);

  /// No description provided for @priceBetween.
  ///
  /// In it, this message translates to:
  /// **'Da {min} € a {max} €'**
  String priceBetween(String min, String max);

  /// No description provided for @invalidPriceNumber.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un prezzo valido'**
  String get invalidPriceNumber;

  /// No description provided for @invalidPriceRange.
  ///
  /// In it, this message translates to:
  /// **'Il prezzo minimo non può superare il massimo'**
  String get invalidPriceRange;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
