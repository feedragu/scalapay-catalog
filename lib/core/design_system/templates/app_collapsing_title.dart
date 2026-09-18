import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

// Pinned title: the Figma large title (25px, left, 57px from the top) that
// contracts while scrolling into a centred 15px bar with a bottom divider.
class AppCollapsingTitle extends StatelessWidget {
  const AppCollapsingTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CollapsingTitleDelegate(
        title: title,
        textScaler: MediaQuery.textScalerOf(context),
        palette: context.appPalette,
      ),
    );
  }
}

class _CollapsingTitleDelegate extends SliverPersistentHeaderDelegate {
  const _CollapsingTitleDelegate({
    required this.title,
    required this.textScaler,
    required this.palette,
  });

  final String title;
  final TextScaler textScaler;
  final AppPalette palette;

  static const _expandedLine = 30.0; // h2: 25px on a 30px line
  static const _compactLine = 24.0; // p1SemiBold: 15px on a 24px line

  @override
  double get maxExtent =>
      AppSpacing.x57 + textScaler.scale(_expandedLine) + AppSpacing.x10;

  @override
  double get minExtent =>
      textScaler.scale(_compactLine) + 2 * AppSpacing.x16 + AppSizes.strokeThin;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    return ColoredBox(
      color: palette.grayscale100,
      child: Stack(
        children: [
          _title(t),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: t,
              child: ColoredBox(
                color: palette.grayscale400,
                child: const SizedBox(height: AppSizes.strokeThin),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Interpolates position, alignment and text style between the two states.
  Widget _title(double t) {
    final expanded = AppTypography.h2(color: palette.typographyAllHeaders);
    final compact = AppTypography.p1SemiBold(color: palette.grayscale900);
    return Positioned(
      left: lerpDouble(AppSpacing.x26, AppSpacing.x16, t),
      right: lerpDouble(AppSpacing.x26, AppSpacing.x16, t),
      top: lerpDouble(AppSpacing.x57, AppSpacing.x16, t),
      height: lerpDouble(
        textScaler.scale(_expandedLine),
        textScaler.scale(_compactLine),
        t,
      ),
      child: Align(
        alignment: Alignment.lerp(Alignment.topLeft, Alignment.topCenter, t)!,
        child: Semantics(
          header: true,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle.lerp(expanded, compact, t),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_CollapsingTitleDelegate oldDelegate) =>
      oldDelegate.title != title ||
      oldDelegate.textScaler != textScaler ||
      oldDelegate.palette != palette;
}
