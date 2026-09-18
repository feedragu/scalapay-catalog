import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    required this.label,
    super.key,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  static const _floatingLabelSize = 11 / 0.75;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: AppTypography.p3Medium(color: context.appPalette.grayscale850),
      decoration: _decoration(context),
    );
  }

  InputDecoration _decoration(BuildContext context) {
    final palette = context.appPalette;
    final error = Theme.of(context).colorScheme.error;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: AppBorderRadius.inputAll,
      borderSide: BorderSide(color: color),
    );
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: AppTypography.p5Medium(color: palette.grayscale700),
      // Material scales the floating label by 0.75: compensate so it renders
      // at the Figma 11px.
      floatingLabelStyle: AppTypography.p5Medium(
        color: palette.grayscale700,
      ).copyWith(fontSize: _floatingLabelSize),
      errorStyle: AppTypography.p5Medium(color: error),
      errorMaxLines: 4,
      filled: true,
      fillColor: palette.grayscale100,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x12,
        vertical: AppSpacing.x16 + AppSpacing.x2,
      ),
      border: border(palette.grayscale500),
      enabledBorder: border(palette.grayscale500),
      focusedBorder: border(palette.lilac900),
      errorBorder: border(error),
      focusedErrorBorder: border(error),
    );
  }
}
