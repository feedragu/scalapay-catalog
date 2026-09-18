import 'package:equatable/equatable.dart';

class CatalogApiConfig extends Equatable {
  const CatalogApiConfig({
    required this.baseUrl,
    required this.partnerId,
    required this.source,
    required this.language,
    required this.country,
  });

  final String baseUrl;
  final String partnerId;
  final String source;
  final String language;
  final String country;

  @override
  List<Object?> get props => [baseUrl, partnerId, source, language, country];
}
