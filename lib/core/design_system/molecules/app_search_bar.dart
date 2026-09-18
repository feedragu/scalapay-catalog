import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_buttons.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_icons.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    required this.controller,
    required this.hintText,
    required this.searchLabel,
    required this.onChanged,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final String searchLabel;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  static const _padding = EdgeInsets.fromLTRB(
    AppSpacing.x16,
    AppSpacing.x4,
    AppSpacing.x4,
    AppSpacing.x4,
  );

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.searchBarHeight),
      padding: _padding,
      decoration: BoxDecoration(
        color: palette.grayscale100,
        borderRadius: BorderRadius.circular(AppBorderRadius.pill),
        border: Border.all(color: palette.border300),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SearchField(
              controller: controller,
              hintText: hintText,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
          const SizedBox(width: AppSpacing.x10),
          AppCircleIconButton(
            icon: AppIcon(AppIconKind.search, color: palette.grayscale100),
            tooltip: searchLabel,
            onPressed: () => onSubmitted(controller.text),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    // The hint disappears once there is text, so the field keeps its name
    // through the semantics label instead (the visible hint is excluded to
    // avoid reading it twice).
    return SizedBox(
      height: AppSizes.searchButton,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Semantics(
          label: hintText,
          inputType: ui.SemanticsInputType.search,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            textInputAction: TextInputAction.search,
            style: AppTypography.p3Medium(color: palette.grayscale900),
            decoration: InputDecoration.collapsed(
              hintText: null,
              hint: ExcludeSemantics(
                child: Text(
                  hintText,
                  style: AppTypography.p3Medium(color: palette.grayscale700),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
