part of 'catalog_bloc.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

final class CatalogSearchChanged extends CatalogEvent {
  const CatalogSearchChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

// Added by the bloc after each keystroke; debounced into the request.
final class _CatalogSearchSettled extends CatalogEvent {
  const _CatalogSearchSettled();
}

final class CatalogSearchSubmitted extends CatalogEvent {
  const CatalogSearchSubmitted(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class CatalogSortChanged extends CatalogEvent {
  const CatalogSortChanged(this.sort);

  final ProductSort sort;

  @override
  List<Object?> get props => [sort];
}

final class CatalogFiltersApplied extends CatalogEvent {
  const CatalogFiltersApplied(this.priceRange);

  final PriceRange priceRange;

  @override
  List<Object?> get props => [priceRange];
}

final class CatalogRetryRequested extends CatalogEvent {
  const CatalogRetryRequested();
}

final class CatalogNextPageRequested extends CatalogEvent {
  const CatalogNextPageRequested();
}
