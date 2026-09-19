import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/core/design_system/molecules/app_search_bar.dart';

import '../helpers/pump_app.dart';

void main() {
  Future<void> pumpBar(WidgetTester tester, TextEditingController controller) {
    return tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            AppSearchBar(
              controller: controller,
              hintText: 'Cerca brand o negozi',
              searchLabel: 'Cerca',
              onChanged: (_) {},
              onSubmitted: (_) {},
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  bool fieldHasFocus(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus;

  testWidgets('tapping the pill outside the text line focuses the field', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await pumpBar(tester, controller);
    expect(fieldHasFocus(tester), isFalse);

    final bar = tester.getRect(find.byType(AppSearchBar));
    final field = tester.getRect(find.byType(TextField));
    // Top-left corner of the pill: inside the padding, outside the field.
    final target = Offset(bar.left + 4, bar.top + 4);
    expect(field.contains(target), isFalse);

    await tester.tapAt(target);
    await tester.pump();
    expect(fieldHasFocus(tester), isTrue);
  });

  testWidgets('tapping outside the pill still blurs the field', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await pumpBar(tester, controller);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(fieldHasFocus(tester), isTrue);

    final bar = tester.getRect(find.byType(AppSearchBar));
    await tester.tapAt(Offset(bar.center.dx, bar.bottom + 100));
    await tester.pump();
    expect(fieldHasFocus(tester), isFalse);
  });
}
