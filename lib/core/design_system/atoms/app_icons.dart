import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';

// Figma vector exports, drawn at their frame size and tinted at paint time.
enum AppIconKind {
  filter('assets/icons/filter.svg', AppSizes.iconSmall),
  sort('assets/icons/sort.svg', AppSizes.iconMedium),
  close('assets/icons/close.svg', AppSizes.closeIcon),
  search('assets/icons/search.svg', AppSizes.iconMedium);

  const AppIconKind(this.asset, this.size);

  final String asset;
  final double size;
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.kind, {super.key, this.color});

  final AppIconKind kind;
  final Color? color;

  // Decodes every icon once so the first frame already shows them.
  static Future<void> precache() => Future.wait([
    for (final kind in AppIconKind.values)
      SvgAssetLoader(kind.asset).loadBytes(null),
  ]);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      kind.asset,
      width: kind.size,
      height: kind.size,
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        color ?? context.appPalette.grayscale900,
        BlendMode.srcIn,
      ),
    );
  }
}
