import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:scalapay_catalog/features/catalog/data/api/models/product_search_response_dto.dart';

part 'catalog_api.g.dart';

@RestApi()
abstract class CatalogApi {
  factory CatalogApi(Dio dio, {String? baseUrl}) = _CatalogApi;

  @GET('/v1/products/search')
  Future<ProductSearchResponseDto> searchProducts(
    @Queries() Map<String, dynamic> query,
  );
}
