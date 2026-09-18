import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_product_image.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_shimmer.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_skeleton_box.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';
import 'package:scalapay_catalog/core/design_system/molecules/app_price_block.dart';

class AppProductCard extends StatelessWidget {
  const AppProductCard({
    required this.title,
    required this.merchant,
    required this.fullPrice,
    required this.installments,
    super.key,
    this.imageUrl,
    this.cacheManager,
  });

  final String title;
  final String merchant;
  final String fullPrice;
  final String installments;
  final String? imageUrl;
  final BaseCacheManager? cacheManager;

  static const _textPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x8,
    vertical: AppSpacing.x12,
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: AppSizes.cardImageAspectRatio,
            child: AppProductImage(
              imageUrl: imageUrl,
              cacheManager: cacheManager,
            ),
          ),
          Padding(
            padding: _textPadding,
            child: _ProductInfo(
              title: title,
              merchant: merchant,
              fullPrice: fullPrice,
              installments: installments,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({
    required this.title,
    required this.merchant,
    required this.fullPrice,
    required this.installments,
  });

  final String title;
  final String merchant;
  final String fullPrice;
  final String installments;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.p3SemiBold(color: palette.grayscale900),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          merchant,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.p4Medium(color: palette.grayscale850),
        ),
        const SizedBox(height: AppSpacing.x8),
        AppPriceBlock(fullPrice: fullPrice, installments: installments),
      ],
    );
  }
}

class AppProductCardSkeleton extends StatelessWidget {
  const AppProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: AppSizes.cardImageAspectRatio,
              child: AppSkeletonBox(radius: AppBorderRadius.card),
            ),
            Padding(
              padding: AppProductCard._textPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeletonBox(height: 20, width: 140),
                  SizedBox(height: AppSpacing.x4),
                  AppSkeletonBox(height: 18, width: 80),
                  SizedBox(height: AppSpacing.x8),
                  AppSkeletonBox(height: 18, width: 60),
                  SizedBox(height: AppSpacing.x4),
                  AppSkeletonBox(height: 21, width: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
