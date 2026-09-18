import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';
import 'package:scalapay_catalog/features/catalog/domain/result.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';
import 'package:stream_transform/stream_transform.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(
    this._searchProducts, {
    Duration searchDebounce = const Duration(milliseconds: 400),
  }) : super(const CatalogState()) {
    on<CatalogSearchChanged>(_onSearchChanged);
    on<_CatalogSearchSettled>(
      _onSearchSettled,
      transformer: _debounce(searchDebounce),
    );
    on<CatalogSearchSubmitted>(_onSearchSubmitted);
    on<CatalogSortChanged>(_onSortChanged);
    on<CatalogFiltersApplied>(_onFiltersApplied);
    on<CatalogRetryRequested>(_onRetryRequested);
    on<CatalogNextPageRequested>(_onNextPageRequested);
  }

  final SearchProductsUseCase _searchProducts;

  // Every fetch takes a ticket; a response whose ticket is no longer the
  // latest belongs to an outdated query and must not overwrite newer results.
  int _requestTicket = 0;

  // True between a keystroke and the request it will start after the pause.
  bool _searchPending = false;

  static EventTransformer<E> _debounce<E>(Duration duration) =>
      (events, mapper) => events.debounce(duration).switchMap(mapper);

  // Feedback is immediate (skeletons, or the idle prompt when the text is
  // cleared); the request itself waits for a pause in typing.
  void _onSearchChanged(
    CatalogSearchChanged event,
    Emitter<CatalogState> emit,
  ) {
    final text = event.text.trim();
    if (text == state.query.text) return;
    final query = state.query.copyWith(text: text, page: 1);
    _requestTicket++;
    _searchPending = text.isNotEmpty;
    if (text.isEmpty) {
      emit(CatalogState(query: query));
      return;
    }
    emit(CatalogState(status: CatalogStatus.loading, query: query));
    add(const _CatalogSearchSettled());
  }

  // Skipped when a request for the typed text already started meanwhile
  // (submit, sort or filters) or the text was cleared.
  Future<void> _onSearchSettled(
    _CatalogSearchSettled event,
    Emitter<CatalogState> emit,
  ) {
    if (!_searchPending) return Future.value();
    return _load(emit, state.query);
  }

  Future<void> _onSearchSubmitted(
    CatalogSearchSubmitted event,
    Emitter<CatalogState> emit,
  ) {
    final text = event.text.trim();
    // The same text is a duplicate unless its request is still waiting for
    // the typing pause (then submitting starts it now) or it failed (retry).
    final alreadyRequested =
        text == state.query.text &&
        !_searchPending &&
        state.status != CatalogStatus.failure;
    if (alreadyRequested) return Future.value();
    return _load(emit, state.query.copyWith(text: text, page: 1));
  }

  Future<void> _onSortChanged(
    CatalogSortChanged event,
    Emitter<CatalogState> emit,
  ) {
    if (event.sort == state.query.sort) return Future.value();
    return _load(emit, state.query.copyWith(sort: event.sort, page: 1));
  }

  Future<void> _onFiltersApplied(
    CatalogFiltersApplied event,
    Emitter<CatalogState> emit,
  ) {
    final range = event.priceRange;
    if (!range.isValid || range == state.query.priceRange) {
      return Future.value();
    }
    return _load(emit, state.query.copyWith(priceRange: range, page: 1));
  }

  Future<void> _onRetryRequested(
    CatalogRetryRequested event,
    Emitter<CatalogState> emit,
  ) => _load(emit, state.query.copyWith(page: 1));

  Future<void> _onNextPageRequested(
    CatalogNextPageRequested event,
    Emitter<CatalogState> emit,
  ) async {
    final canLoadMore =
        state.status == CatalogStatus.success &&
        state.hasMore &&
        !state.isLoadingMore;
    if (!canLoadMore) return;
    final ticket = ++_requestTicket;
    final query = state.query.nextPage();
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));
    final result = await _searchProducts(query);
    if (ticket != _requestTicket) return;
    switch (result) {
      case Success():
        final page = result.value;
        emit(
          state.copyWith(
            query: query,
            products: [...state.products, ...page.products],
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
      case Failure():
        emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  Future<void> _load(Emitter<CatalogState> emit, ProductQuery query) async {
    final ticket = ++_requestTicket;
    _searchPending = false;
    if (query.text.isEmpty) {
      emit(CatalogState(query: query));
      return;
    }
    emit(CatalogState(status: CatalogStatus.loading, query: query));
    final result = await _searchProducts(query);
    if (ticket != _requestTicket) return;
    switch (result) {
      case Success():
        final page = result.value;
        emit(
          state.copyWith(
            status: CatalogStatus.success,
            products: page.products,
            hasMore: page.hasMore,
          ),
        );
      case Failure():
        emit(
          state.copyWith(status: CatalogStatus.failure, error: result.error),
        );
    }
  }
}
