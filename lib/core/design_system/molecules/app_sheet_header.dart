import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_buttons.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_sheet_handle.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader({
    required this.title,
    required this.closeLabel,
    required this.onClose,
    super.key,
  });

  final String title;
  final String closeLabel;
  final VoidCallback onClose;

  // Figma (375px sheet): handle 45x5 at y 7; close icon 32x32 at x 330, y 17
  // (drawn in a 48px tap box, hence the 9/5 offsets); title box 296x65 at
  // x 40, y 26, i.e. up to the 91px header bottom.
  static const _titlePadding = EdgeInsets.only(
    top: AppSpacing.x26,
    left: AppSizes.minTapTarget,
    right: AppSizes.minTapTarget,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.sheetHeaderHeight,
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: AppSpacing.x7),
              child: AppSheetHandle(),
            ),
          ),
          Positioned(
            top: AppSpacing.x9,
            right: AppSpacing.x5,
            child: AppCloseButton(tooltip: closeLabel, onPressed: onClose),
          ),
          Padding(
            padding: _titlePadding,
            child: Center(child: _Title(title)),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTypography.p1SemiBold(color: context.appPalette.grayscale900),
      ),
    );
  }
}
