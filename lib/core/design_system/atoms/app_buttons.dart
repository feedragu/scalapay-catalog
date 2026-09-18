import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_icons.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  // Styled by the theme's filledButtonTheme.
  @override
  Widget build(BuildContext context) =>
      FilledButton(onPressed: onPressed, child: Text(label));
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  // Styled by the theme's textButtonTheme.
  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: onPressed, child: Text(label));
}

class AppCircleIconButton extends StatelessWidget {
  const AppCircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return IconButton.filled(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: AppSizes.iconMedium,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.searchButton,
        height: AppSizes.searchButton,
      ),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: palette.lilac900,
        foregroundColor: palette.grayscale100,
        shape: const CircleBorder(),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: icon,
    );
  }
}

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.minTapTarget,
        height: AppSizes.minTapTarget,
      ),
      icon: const AppIcon(AppIconKind.close),
    );
  }
}
