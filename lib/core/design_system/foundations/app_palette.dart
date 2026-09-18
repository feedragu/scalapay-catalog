import 'package:flutter/material.dart';

// The Figma color styles of "Test - App Scalapay", named as in the file so a
// widget reads like its design layer. This is the only file allowed to hold
// raw color literals.
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.lilac900,
    required this.buttonsLightweightLilacHover,
    required this.grayscale100,
    required this.grayscale200,
    required this.grayscale300,
    required this.grayscale400,
    required this.grayscale500,
    required this.grayscale600,
    required this.grayscale700,
    required this.grayscale850,
    required this.grayscale900,
    required this.border300,
    required this.typographyAllHeaders,
    required this.overlayPopUp,
  });

  static const light = AppPalette(
    lilac900: Color(0xFF5666F0), // Brand/Colors/Core/Lilac/900
    buttonsLightweightLilacHover: Color(
      0xFFCACCF2,
    ), // UI/Buttons/Lightweight/Lillac/Hover
    grayscale100: Color(0xFFFFFFFF), // UI/Grayscale/100 - White
    grayscale200: Color(0xFFF6F7FB), // UI/Grayscale/200 - Light Background
    grayscale300: Color(0xFFF6F7FB), // UI/Grayscale/300 - Light Background
    grayscale400: Color(0xFFEFF1F5), // UI/Grayscale/400 - Dark Background
    grayscale500: Color(0xFFEFF1F5), // UI/Grayscale/500
    grayscale600: Color(0xFF9E9E9E), // UI/Grayscale/600
    grayscale700: Color(0xFF8A8A8D), // UI/Grayscale/700
    grayscale850: Color(0xFF3A4045), // UI/Grayscale/850 - Black
    grayscale900: Color(0xFF272727), // UI/Grayscale/900 - Black Dark
    border300: Color(0xFFEFF1F5), // UI/Border/300
    typographyAllHeaders: Color(0xFF000000), // UI/Typography/Light/All Headers
    overlayPopUp: Color(0x80272727), // UI/Overlay/Pop-up (50%)
  );

  final Color lilac900;
  final Color buttonsLightweightLilacHover;
  final Color grayscale100;
  final Color grayscale200;
  final Color grayscale300;
  final Color grayscale400;
  final Color grayscale500;
  final Color grayscale600;
  final Color grayscale700;
  final Color grayscale850;
  final Color grayscale900;
  final Color border300;
  final Color typographyAllHeaders;
  final Color overlayPopUp;

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? light;

  // A single light palette ships today; add parameters when a variant exists.
  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      lilac900: mix(lilac900, other.lilac900),
      buttonsLightweightLilacHover: mix(
        buttonsLightweightLilacHover,
        other.buttonsLightweightLilacHover,
      ),
      grayscale100: mix(grayscale100, other.grayscale100),
      grayscale200: mix(grayscale200, other.grayscale200),
      grayscale300: mix(grayscale300, other.grayscale300),
      grayscale400: mix(grayscale400, other.grayscale400),
      grayscale500: mix(grayscale500, other.grayscale500),
      grayscale600: mix(grayscale600, other.grayscale600),
      grayscale700: mix(grayscale700, other.grayscale700),
      grayscale850: mix(grayscale850, other.grayscale850),
      grayscale900: mix(grayscale900, other.grayscale900),
      border300: mix(border300, other.border300),
      typographyAllHeaders: mix(
        typographyAllHeaders,
        other.typographyAllHeaders,
      ),
      overlayPopUp: mix(overlayPopUp, other.overlayPopUp),
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get appPalette => AppPalette.of(this);
}
