import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';

class AppSheetHandle extends StatelessWidget {
  const AppSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: AppSizes.sheetHandleWidth,
        height: AppSizes.sheetHandleHeight,
        decoration: BoxDecoration(
          color: context.appPalette.grayscale600.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppBorderRadius.pill),
        ),
      ),
    );
  }
}
