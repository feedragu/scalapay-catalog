import 'package:flutter/material.dart';

// Figma text styles (Poppins). Line heights are the Figma values divided by
// the font size; even leading matches Figma's half-leading placement.
abstract final class AppTypography {
  static const fontFamily = 'Poppins';

  static TextStyle h2({Color? color}) =>
      _style(size: 25, height: 30 / 25, weight: FontWeight.w600, color: color);

  static TextStyle p1SemiBold({Color? color}) =>
      _style(size: 15, height: 1.6, weight: FontWeight.w600, color: color);

  static TextStyle p2Medium({Color? color}) =>
      _style(size: 14, height: 1.6, weight: FontWeight.w500, color: color);

  static TextStyle p3SemiBold({Color? color}) =>
      _style(size: 13, height: 20 / 13, weight: FontWeight.w600, color: color);

  static TextStyle p3Medium({Color? color}) =>
      _style(size: 13, height: 1.5, weight: FontWeight.w500, color: color);

  static TextStyle p4Medium({Color? color}) =>
      _style(size: 12, height: 1.5, weight: FontWeight.w500, color: color);

  static TextStyle p5SemiBold({Color? color}) =>
      _style(size: 11, height: 1.5, weight: FontWeight.w600, color: color);

  static TextStyle p5Medium({Color? color}) =>
      _style(size: 11, height: 1.5, weight: FontWeight.w500, color: color);

  static TextStyle button({Color? color}) =>
      _style(size: 14, height: 1.5, weight: FontWeight.w600, color: color);

  static TextStyle _style({
    required double size,
    required double height,
    required FontWeight weight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      height: height,
      fontWeight: weight,
      color: color,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}
