import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scalapay_catalog/features/catalog/data/catalog_error_mapper.dart';
import 'package:scalapay_catalog/features/catalog/domain/catalog_error.dart';

import '../../../helpers/fake_http_adapter.dart';

void main() {
  const mapper = CatalogErrorMapper();
  final options = RequestOptions(path: '/v1/products/search');

  group('CatalogErrorMapper', () {
    test('maps every Dio timeout to TimeoutError', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(
          mapper.map(DioException(requestOptions: options, type: type)),
          const TimeoutError(),
        );
      }
    });

    test('maps HTTP errors to ServerError with the status code', () {
      final error = DioException.badResponse(
        statusCode: 503,
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 503),
      );
      expect(mapper.map(error), const ServerError(503));
    });

    test('maps connection problems to NetworkUnavailableError', () {
      expect(
        mapper.map(
          DioException.connectionError(
            requestOptions: options,
            reason: 'offline',
            error: socketException(),
          ),
        ),
        const NetworkUnavailableError(),
      );
      expect(
        mapper.map(
          DioException(requestOptions: options, error: socketException()),
        ),
        const NetworkUnavailableError(),
      );
    });

    test('maps decoding problems to InvalidResponseError', () {
      expect(
        mapper.map(const FormatException('bad json')),
        const InvalidResponseError(),
      );
      expect(
        mapper.map(
          CheckedFromJsonException({}, 'selling_price', 'ProductDto', 'null'),
        ),
        const InvalidResponseError(),
      );
      expect(
        mapper.map(
          DioException(
            requestOptions: options,
            error: const FormatException('bad json'),
          ),
        ),
        const InvalidResponseError(),
      );
    });

    test('wraps anything else as UnknownError', () {
      final cause = StateError('boom');
      expect(mapper.map(cause), UnknownError(cause));

      final wrapped = DioException(requestOptions: options, error: cause);
      expect(mapper.map(wrapped), UnknownError(wrapped));
    });
  });
}
