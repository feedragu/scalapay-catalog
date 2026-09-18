import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/presentation/pages/catalog_page.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.catalogTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CatalogPage(),
    );
  }
}
