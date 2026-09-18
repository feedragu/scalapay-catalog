import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/installment_plan.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/price_formatter.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

class ProductCardItem extends StatelessWidget {
  const ProductCardItem({
    required this.product,
    super.key,
    this.plan = InstallmentPlan.payInThree,
  });

  final Product product;
  final InstallmentPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppProductCard(
      title: product.title,
      merchant: product.merchant,
      fullPrice: l10n.fullPrice(PriceFormatter.amount(product.price)),
      installments: l10n.installments(
        plan.count,
        PriceFormatter.amount(plan.amountFor(product.price)),
      ),
      imageUrl: product.imageUrl,
      cacheManager: context.read<BaseCacheManager>(),
    );
  }
}
