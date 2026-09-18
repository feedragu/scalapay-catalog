import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_icons.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

// The pill itself is the ink surface, so the ripple is drawn over its
// background and clipped to its shape. Icons are right-aligned in a 28px slot
// (8 + 20px filter icon, 4 + 24px sort icon); the label follows after
// [labelGap], 2px in the "Filtri" pill and none in the "Ordina" pill. An
// applied filter/sort shows a count badge after the label, as in the Scalapay
// app (the design has no active state for the chips).
class AppChip extends StatelessWidget {
  const AppChip({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.badgeCount,
    this.activeDescription,
    this.labelGap = AppSpacing.x2,
  });

  final AppIconKind icon;
  final String label;
  final VoidCallback onTap;
  // Null when nothing is applied.
  final int? badgeCount;
  // Spoken with the badge, e.g. the applied range or sort.
  final String? activeDescription;
  final double labelGap;

  bool get active => badgeCount != null;

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
                badgeCount: badgeCount,
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
    required this.badgeCount,
  });

  final AppIconKind icon;
  final String label;
  final double labelGap;
  final int? badgeCount;

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
        if (badgeCount != null) ...[
          const SizedBox(width: AppSpacing.x6),
          _CountBadge(badgeCount!),
        ],
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge(this.count);

  static const size = 18.0;

  final int count;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      constraints: const BoxConstraints(minWidth: size, minHeight: size),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: palette.lilac900,
        shape: const StadiumBorder(),
      ),
      child: ExcludeSemantics(
        child: Text(
          '$count',
          style: AppTypography.p5SemiBold(color: palette.grayscale100),
        ),
      ),
    );
  }
}
