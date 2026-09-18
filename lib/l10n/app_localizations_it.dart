// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get catalogTitle => 'Esplora i prodotti';

  @override
  String get searchHint => 'Cerca brand o negozi';

  @override
  String get searchAction => 'Cerca';

  @override
  String get filtersChip => 'Filtri';

  @override
  String get sortChip => 'Ordina';

  @override
  String get filtersTitle => 'Filtri';

  @override
  String get sortTitle => 'Ordina';

  @override
  String get close => 'Chiudi';

  @override
  String get priceRangeTitle => 'Fascia di prezzo';

  @override
  String get priceMin => 'Minimo';

  @override
  String get priceMax => 'Massimo';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get showResults => 'Mostra risultati';

  @override
  String get sortPriceAsc => 'Prezzo crescente';

  @override
  String get sortPriceDesc => 'Prezzo decrescente';

  @override
  String get sortNameAsc => 'Nome A-Z';

  @override
  String get sortNameDesc => 'Nome Z-A';

  @override
  String fullPrice(String amount) {
    return '$amount€ or';
  }

  @override
  String installments(int count, String amount) {
    return '$count installments of €$amount';
  }

  @override
  String get idleTitle => 'Cerca un prodotto';

  @override
  String get idleMessage =>
      'Scrivi un brand o un negozio per esplorare il catalogo';

  @override
  String get emptyTitle => 'Nessun risultato';

  @override
  String get emptyMessage => 'Prova con un altro termine o modifica i filtri';

  @override
  String get errorTitle => 'Qualcosa è andato storto';

  @override
  String get errorNetwork => 'Controlla la connessione e riprova';

  @override
  String get errorTimeout => 'Il catalogo non risponde, riprova tra poco';

  @override
  String get errorServer => 'Il catalogo non è disponibile al momento';

  @override
  String get errorInvalidResponse =>
      'Il catalogo ha restituito dati non validi';

  @override
  String get errorUnknown => 'Si è verificato un errore inatteso';

  @override
  String get retry => 'Riprova';

  @override
  String get loadMoreFailed => 'Impossibile caricare altri prodotti';

  @override
  String get loadingProducts => 'Caricamento prodotti';

  @override
  String resultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prodotti trovati',
      one: '1 prodotto trovato',
    );
    return '$_temp0';
  }

  @override
  String priceFrom(String min) {
    return 'Da $min €';
  }

  @override
  String priceUpTo(String max) {
    return 'Fino a $max €';
  }

  @override
  String priceBetween(String min, String max) {
    return 'Da $min € a $max €';
  }

  @override
  String get invalidPriceNumber => 'Inserisci un prezzo valido';

  @override
  String get invalidPriceRange =>
      'Il prezzo minimo non può superare il massimo';
}
