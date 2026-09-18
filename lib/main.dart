import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scalapay_catalog/app.dart';
import 'package:scalapay_catalog/config/runtime_config.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_icons.dart';
import 'package:scalapay_catalog/core/di/app_providers.dart';
import 'package:scalapay_catalog/features/catalog/data/api/catalog_api_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([RuntimeConfig.load(), AppIcon.precache()]);
  final config = CatalogApiConfig(
    baseUrl: RuntimeConfig.requiredValue('CATALOG_API_BASE_URL'),
    partnerId: RuntimeConfig.requiredValue('CATALOG_PARTNER_ID'),
    source: RuntimeConfig.requiredValue('CATALOG_SOURCE'),
    language: RuntimeConfig.requiredValue('CATALOG_LANGUAGE'),
    country: RuntimeConfig.requiredValue('CATALOG_COUNTRY'),
  );
  runApp(
    MultiProvider(providers: initProviders(config), child: const CatalogApp()),
  );
}
