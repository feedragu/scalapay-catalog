import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppSheetSection extends StatelessWidget {
  const AppSheetSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        AppSpacing.x14,
        AppSpacing.x16,
        AppSpacing.x16,
      ),
      decoration: BoxDecoration(
        color: palette.grayscale100,
        borderRadius: AppBorderRadius.cardAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title),
          const SizedBox(height: AppSpacing.x16),
          child,
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSizes.iconMedium),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Semantics(
          header: true,
          child: Text(
            title,
            style: AppTypography.p3Medium(
              color: context.appPalette.grayscale900,
            ),
          ),
        ),
      ),
    );
  }
}
