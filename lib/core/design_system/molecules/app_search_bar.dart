import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_buttons.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_icons.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppSearchBar extends StatefulWidget {
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
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    // The field only covers its text line, so the pill itself must forward
    // taps to it. Sharing the tap-region group keeps those taps from counting
    // as "outside" and blurring the field first.
    return TapRegion(
      groupId: this,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _focusNode.requestFocus,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSizes.searchBarHeight,
          ),
          padding: AppSearchBar._padding,
          decoration: BoxDecoration(
            color: palette.grayscale100,
            borderRadius: BorderRadius.circular(AppBorderRadius.pill),
            border: Border.all(color: palette.border300),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SearchField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  tapRegionGroupId: this,
                  hintText: widget.hintText,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                ),
              ),
              const SizedBox(width: AppSpacing.x10),
              AppCircleIconButton(
                icon: AppIcon(AppIconKind.search, color: palette.grayscale100),
                tooltip: widget.searchLabel,
                onPressed: () => widget.onSubmitted(widget.controller.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.tapRegionGroupId,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Object tapRegionGroupId;
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
            focusNode: focusNode,
            groupId: tapRegionGroupId,
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
