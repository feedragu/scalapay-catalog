import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_buttons.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppStateMessage extends StatelessWidget {
  const AppStateMessage({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final actionLabel = this.actionLabel;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: palette.grayscale600),
            const SizedBox(height: AppSpacing.x16),
            Semantics(
              liveRegion: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.p1SemiBold(color: palette.grayscale900),
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.p3Medium(color: palette.grayscale700),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.x24),
              AppFilledButton(label: actionLabel, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
