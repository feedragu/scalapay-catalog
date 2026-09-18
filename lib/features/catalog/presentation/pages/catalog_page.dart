import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scalapay_catalog/features/catalog/domain/usecases/search_products_use_case.dart';
import 'package:scalapay_catalog/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:scalapay_catalog/features/catalog/presentation/screens/catalog_screen.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatalogBloc(context.read<SearchProductsUseCase>()),
      child: const CatalogScreen(),
    );
  }
}
