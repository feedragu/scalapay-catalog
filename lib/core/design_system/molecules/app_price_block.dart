import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppPriceBlock extends StatelessWidget {
  const AppPriceBlock({
    required this.fullPrice,
    required this.installments,
    super.key,
  });

  final String fullPrice;
  final String installments;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullPrice,
          style: AppTypography.p4Medium(color: palette.grayscale700),
        ),
        Text(
          installments,
          style: AppTypography.button(color: palette.lilac900),
        ),
      ],
    );
  }
}
