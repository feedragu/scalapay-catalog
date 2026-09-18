import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_buttons.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';

class AppSheetActions extends StatelessWidget {
  const AppSheetActions({
    required this.secondaryLabel,
    required this.onSecondary,
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
  });

  final String secondaryLabel;
  final VoidCallback onSecondary;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x16),
      child: Row(
        children: [
          Expanded(
            child: AppTextButton(label: secondaryLabel, onPressed: onSecondary),
          ),
          const SizedBox(width: AppSpacing.x6),
          Expanded(
            child: AppFilledButton(label: primaryLabel, onPressed: onPrimary),
          ),
        ],
      ),
    );
  }
}
