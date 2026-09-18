import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_api_config.dart';

typedef FakeResponse = FutureOr<ResponseBody> Function(RequestOptions options);

const testApiConfig = CatalogApiConfig(
  baseUrl: 'https://catalog.test',
  partnerId: 'partner-test',
  source: 'source-test',
  language: 'it',
  country: 'IT',
);

class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this._respond);

  FakeHttpAdapter.json(Object body, {int statusCode = 200})
    : this((_) => jsonResponse(body, statusCode: statusCode));

  final FakeResponse _respond;
  final List<RequestOptions> requests = [];

  static ResponseBody jsonResponse(Object body, {int statusCode = 200}) =>
      rawResponse(jsonEncode(body), statusCode: statusCode);

  static ResponseBody rawResponse(String body, {int statusCode = 200}) =>
      ResponseBody.fromString(
        body,
        statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return _respond(options);
  }

  @override
  void close({bool force = false}) {}
}

Dio fakeDio(HttpClientAdapter adapter) =>
    Dio(BaseOptions(baseUrl: testApiConfig.baseUrl))
      ..httpClientAdapter = adapter;

SocketException socketException() =>
    const SocketException('Failed host lookup');
