import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_icons.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

// The pill itself is the ink surface, so the ripple is drawn over its
// background and clipped to its shape. Icons are right-aligned in a 28px slot
// (8 + 20px filter icon, 4 + 24px sort icon); the label follows after
// [labelGap], 2px in the "Filtri" pill and none in the "Ordina" pill.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.active = false,
    this.activeDescription,
    this.labelGap = AppSpacing.x2,
  });

  final AppIconKind icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  // Spoken in place of the dot, e.g. the applied range or sort.
  final String? activeDescription;
  final double labelGap;

  static const _padding = EdgeInsets.fromLTRB(
    0,
    AppSpacing.x4,
    AppSpacing.x10,
    AppSpacing.x4,
  );

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Semantics(
      button: true,
      selected: active,
      value: active ? activeDescription : null,
      child: _ActiveDot(
        visible: active,
        child: Material(
          color: palette.grayscale200,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSizes.chipHeight),
              child: Padding(
                padding: _padding,
                child: _PillContent(
                  icon: icon,
                  label: label,
                  labelGap: labelGap,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillContent extends StatelessWidget {
  const _PillContent({
    required this.icon,
    required this.label,
    required this.labelGap,
  });

  final AppIconKind icon;
  final String label;
  final double labelGap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: AppSizes.chipIconSlot,
          child: Align(alignment: Alignment.centerRight, child: AppIcon(icon)),
        ),
        SizedBox(width: labelGap),
        Text(
          label,
          style: AppTypography.p5SemiBold(
            color: context.appPalette.grayscale900,
          ),
        ),
      ],
    );
  }
}

// Small brand-coloured dot on the pill's corner: the design has no "active"
// chip state, but users must see that a filter or sort is applied.
class _ActiveDot extends StatelessWidget {
  const _ActiveDot({required this.visible, required this.child});

  static const size = 8.0;

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;
    final palette = context.appPalette;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -size / 4,
          right: -size / 4,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: palette.lilac900,
              shape: BoxShape.circle,
              border: Border.all(color: palette.grayscale100, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
