import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:shimmer/shimmer.dart';

// Skeleton highlight in the palette colours; static when the platform asks
// for reduced motion.
class AppShimmer extends StatelessWidget {
  const AppShimmer({required this.child, super.key});

  static const duration = Duration(milliseconds: 1400);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Shimmer.fromColors(
      baseColor: palette.grayscale300,
      highlightColor: palette.grayscale100,
      period: duration,
      enabled: !MediaQuery.disableAnimationsOf(context),
      child: child,
    );
  }
}
