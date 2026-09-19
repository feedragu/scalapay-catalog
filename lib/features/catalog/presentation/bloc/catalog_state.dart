part of 'catalog_bloc.dart';

enum CatalogStatus { initial, loading, success, failure }

final class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.query = const ProductQuery(),
    this.products = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.error,
  }) : assert(
         (status == CatalogStatus.failure) == (error != null),
         'error is set exactly when status is failure',
       );

  final CatalogStatus status;
  final ProductQuery query;
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final CatalogError? error;

  bool get isEmpty => status == CatalogStatus.success && products.isEmpty;

  // The error only exists in the failure status: moving to any other
  // status drops it, even when the caller does not pass error: null.
  CatalogState copyWith({
    CatalogStatus? status,
    ProductQuery? query,
    List<Product>? products,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    CatalogError? error,
  }) {
    final nextStatus = status ?? this.status;
    return CatalogState(
      status: nextStatus,
      query: query ?? this.query,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      error: nextStatus == CatalogStatus.failure ? error ?? this.error : null,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    products,
    hasMore,
    isLoadingMore,
    loadMoreFailed,
    error,
  ];
}
