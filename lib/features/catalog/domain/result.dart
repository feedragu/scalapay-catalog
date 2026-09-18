import 'package:equatable/equatable.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';

sealed class Result<T> extends Equatable {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final CatalogError error;

  @override
  List<Object?> get props => [error];
}
