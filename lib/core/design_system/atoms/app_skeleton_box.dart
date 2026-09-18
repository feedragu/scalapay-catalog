import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';

class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppBorderRadius.input,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appPalette.grayscale300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
