import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';
import 'package:vector_graphics/vector_graphics.dart';

const phoneSmall = Size(320, 568);
const phoneFigma = Size(375, 812);
const phoneMedium = Size(390, 844);
const phoneLarge = Size(430, 932);
const tablet = Size(800, 1280);

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget child, {
    Size size = phoneFigma,
    double textScale = 1,
    EdgeInsets padding = EdgeInsets.zero,
  }) async {
    await binding.setSurfaceSize(size);
    // Logical size equals physical size, so goldens are measured in dp.
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
    await pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: size,
          padding: padding,
          textScaler: TextScaler.linear(textScale),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          locale: const Locale('it'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
  }
}

extension DecodeImages on WidgetTester {
  // Image and SVG decoding happen outside the fake async zone, so give them
  // real time before rendering the frame.
  Future<void> decodeImages() async {
    await runAsync(() async {
      await vg.waitForPendingDecodes();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await pump();
  }
}

AppLocalizations get l10nIt => lookupAppLocalizations(const Locale('it'));

Future<void> loadPoppins() async {
  final loader = FontLoader(AppTypography.fontFamily)
    ..addFont(rootBundle.load('assets/fonts/Poppins-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Poppins-SemiBold.ttf'));
  await loader.load();
}
