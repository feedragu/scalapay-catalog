import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('animates in the palette colours', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: AppShimmer(child: AppSkeletonBox(height: 40))),
    );

    final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    expect(shimmer.enabled, isTrue);
    expect(shimmer.period, AppShimmer.duration);
    expect(shimmer.gradient.colors.first, AppPalette.light.grayscale300);
    expect(shimmer.gradient.colors, contains(AppPalette.light.grayscale100));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('stays static when animations are disabled', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppShimmer(child: AppSkeletonBox(height: 40)),
          ),
        ),
      ),
    );

    expect(tester.widget<Shimmer>(find.byType(Shimmer)).enabled, isFalse);
    expect(tester.hasRunningAnimations, isFalse);
    expect(find.byType(AppSkeletonBox), findsOneWidget);
  });
}
