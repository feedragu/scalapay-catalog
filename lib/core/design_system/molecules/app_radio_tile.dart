import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_radio.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppRadioTile extends StatelessWidget {
  const AppRadioTile({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
    this.showDivider = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final divider = BorderSide(color: palette.grayscale400);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x15),
          constraints: const BoxConstraints(
            minHeight: AppSizes.sortOptionHeight,
          ),
          decoration: BoxDecoration(
            border: showDivider ? Border(bottom: divider) : null,
          ),
          child: Row(
            children: [
              AppRadio(selected: selected),
              const SizedBox(width: AppSpacing.x10),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.p2Medium(color: palette.grayscale900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
