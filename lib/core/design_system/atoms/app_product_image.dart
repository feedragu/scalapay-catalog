import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_network_image.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';

// Figma multiplies the product photo over the grey box so white studio
// backgrounds blend into it.
class AppProductImage extends StatelessWidget {
  const AppProductImage({super.key, this.imageUrl, this.cacheManager});

  final String? imageUrl;
  final BaseCacheManager? cacheManager;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final imageUrl = this.imageUrl;
    return ClipRRect(
      borderRadius: AppBorderRadius.cardAll,
      child: ColoredBox(
        color: palette.grayscale300,
        child: imageUrl == null
            ? const _ImagePlaceholder()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x7),
                child: ExcludeSemantics(
                  child: AppNetworkImage(
                    url: imageUrl,
                    cacheManager: cacheManager,
                    color: palette.grayscale300,
                    colorBlendMode: BlendMode.multiply,
                    decodeWidth: AppSizes.productImageDecodeWidth,
                    errorBuilder: (_) => const _ImagePlaceholder(),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: AppSizes.closeIcon,
        color: context.appPalette.grayscale600,
      ),
    );
  }
}
