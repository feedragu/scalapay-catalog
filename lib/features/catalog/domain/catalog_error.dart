import 'package:equatable/equatable.dart';

sealed class CatalogError extends Equatable {
  const CatalogError();

  @override
  List<Object?> get props => [];
}

final class NetworkUnavailableError extends CatalogError {
  const NetworkUnavailableError();
}

final class TimeoutError extends CatalogError {
  const TimeoutError();
}

final class ServerError extends CatalogError {
  const ServerError(this.statusCode);

  final int? statusCode;

  @override
  List<Object?> get props => [statusCode];
}

final class InvalidResponseError extends CatalogError {
  const InvalidResponseError();
}

final class UnknownError extends CatalogError {
  const UnknownError(this.cause);

  final Object cause;

  @override
  List<Object?> get props => [cause];
}
