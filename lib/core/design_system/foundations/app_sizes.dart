// Component geometry measured on the Figma frames (375x812).
abstract final class AppSizes {
  static const double searchBarHeight = 55;
  static const double searchButton = 45;
  static const double chipHeight = 32;
  // Pill edge to label gap: the 20px and 24px icons end at the same x.
  static const double chipIconSlot = 28;
  static const double iconSmall = 20;
  static const double iconMedium = 24;
  static const double closeIcon = 32;
  static const double radio = 24;
  static const double sheetHeaderHeight = 91;
  static const double sheetHandleWidth = 45;
  static const double sheetHandleHeight = 5;
  static const double sortOptionHeight = 64;
  static const double buttonHeight = 44;
  static const double inputHeight = 56;
  static const double minTapTarget = 48;
  // Figma image frame 164x195. Only the image has a fixed ratio: the card's
  // height follows its text (two-line titles, large text scales).
  static const double cardImageAspectRatio = 164 / 195;
  static const double gridGutter = 16;
  static const double gridPadding = 16;
  static const int productImageDecodeWidth = 480;
  static const double strokeThin = 1;
}
