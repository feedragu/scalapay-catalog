import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

abstract final class AppTheme {
  // Figma buttons: 44px stadium, 14/600 label.
  static ButtonStyle _buttonStyle({
    required Color foreground,
    Color? background,
  }) {
    return ButtonStyle(
      backgroundColor: background == null
          ? null
          : WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      minimumSize: const WidgetStatePropertyAll(Size(0, AppSizes.buttonHeight)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: AppSpacing.x16,
          vertical: AppSpacing.x8,
        ),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: WidgetStatePropertyAll(AppTypography.button()),
    );
  }

  static ThemeData light() {
    const palette = AppPalette.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.lilac900,
      surface: palette.grayscale100,
    ).copyWith(primary: palette.lilac900, onSurface: palette.grayscale900);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: palette.grayscale100,
      extensions: const [palette],
      textSelectionTheme: TextSelectionThemeData(cursorColor: palette.lilac900),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(
          background: palette.lilac900,
          foreground: palette.grayscale100,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(foreground: palette.lilac900),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.grayscale300,
        modalBarrierColor: palette.overlayPopUp,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.sheetTop,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.grayscale400,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.lilac900,
      ),
    );
  }
}
