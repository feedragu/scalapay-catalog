import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scalapay_catalog/core/design_system/atoms/app_text_field.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';

class AppPriceRangeFields extends StatelessWidget {
  const AppPriceRangeFields({
    required this.minController,
    required this.maxController,
    required this.minLabel,
    required this.maxLabel,
    super.key,
    this.minValidator,
    this.maxValidator,
    this.inputFormatters,
    this.onSubmitted,
  });

  final TextEditingController minController;
  final TextEditingController maxController;
  final String minLabel;
  final String maxLabel;
  final FormFieldValidator<String>? minValidator;
  final FormFieldValidator<String>? maxValidator;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      // Tops stay aligned when one field shows an error below itself.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _field(minController, minLabel, minValidator)),
        Container(
          width: AppSpacing.x10,
          height: AppSizes.strokeThin,
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.x8,
            (AppSizes.inputHeight - AppSizes.strokeThin) / 2,
            AppSpacing.x8,
            0,
          ),
          color: context.appPalette.grayscale600,
        ),
        Expanded(child: _field(maxController, maxLabel, maxValidator)),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    FormFieldValidator<String>? validator,
  ) {
    return AppTextField(
      controller: controller,
      label: label,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      inputFormatters: inputFormatters,
      validator: validator,
      onSubmitted: (_) => onSubmitted?.call(),
    );
  }
}
