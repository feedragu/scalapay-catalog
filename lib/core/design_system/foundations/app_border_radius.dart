import 'package:flutter/material.dart';

abstract final class AppBorderRadius {
  static const double sheet = 20;
  static const double card = 20;
  static const double input = 8; // Corner-radius/Child
  static const double label = 3;
  static const double pill = 100;

  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
  static final BorderRadius cardAll = BorderRadius.circular(card);
  static final BorderRadius inputAll = BorderRadius.circular(input);
}
