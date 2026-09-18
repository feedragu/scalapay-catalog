import 'dart:io';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';

class CatalogErrorMapper {
  const CatalogErrorMapper();

  CatalogError map(Object error) {
    if (error is DioException) return _mapDio(error);
    if (_isDecodingError(error)) return const InvalidResponseError();
    return UnknownError(error);
  }

  CatalogError _mapDio(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const TimeoutError(),
      DioExceptionType.badResponse => ServerError(error.response?.statusCode),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => const NetworkUnavailableError(),
      DioExceptionType.cancel => UnknownError(error),
      DioExceptionType.unknown => _mapUnknown(error),
    };
  }

  CatalogError _mapUnknown(DioException error) {
    final cause = error.error;
    if (_isDecodingError(cause)) return const InvalidResponseError();
    if (cause is SocketException) return const NetworkUnavailableError();
    return UnknownError(error);
  }

  bool _isDecodingError(Object? error) =>
      error is FormatException ||
      error is CheckedFromJsonException ||
      error is TypeError;
}
