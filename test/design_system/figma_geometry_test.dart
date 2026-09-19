import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';

import '../helpers/pump_app.dart';

// Checks the AppSizes values against the Figma measurements (375x812 frames).
void main() {
  testWidgets('sheet header places handle, close and title like Figma', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: AppSheetHeader(
          title: 'Ordina',
          closeLabel: 'Chiudi',
          onClose: () {},
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppSheetHeader)).height, 91);
    final handle = tester.getRect(find.byType(AppSheetHandle));
    expect(handle.top, 7);
    expect(handle.size, const Size(45, 5));
    expect(handle.center.dx, 375 / 2);

    final close = tester.getRect(find.byType(AppIcon));
    expect(close.size, const Size(32, 32));
    expect(close.topLeft, const Offset(330, 17));

    final title = tester.getCenter(find.text('Ordina'));
    expect(title.dx, 375 / 2);
    expect(title.dy, closeTo(26 + 65 / 2, 1));
  });

  testWidgets('search bar and its button match the Figma sizes', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppSearchBar(
            controller: controller,
            hintText: 'Cerca brand o negozi',
            searchLabel: 'Cerca',
            onChanged: (_) {},
            onSubmitted: (_) {},
          ),
        ),
      ),
    );

    final bar = tester.getRect(find.byType(AppSearchBar));
    expect(bar.size, const Size(343, 55));
    final button = tester.getRect(find.byType(AppCircleIconButton));
    expect(button.size, const Size(45, 45));
    expect(bar.right - button.right, 5);
    expect(button.center.dy, bar.center.dy);
  });

  testWidgets('chips, inputs, radio rows and buttons keep Figma heights', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            AppChip(icon: AppIconKind.filter, label: 'Filtri', onTap: () {}),
            AppTextField(controller: controller, label: 'Minimo'),
            AppRadioTile(
              label: 'Prezzo crescente',
              selected: true,
              onTap: () {},
            ),
            AppFilledButton(label: 'Mostra risultati', onPressed: () {}),
            AppTextButton(label: 'Cancella tutto', onPressed: () {}),
          ],
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppChip)).height, 32);
    expect(tester.getSize(find.byType(AppIcon)), const Size(20, 20));
    expect(tester.getSize(find.byType(AppTextField)).height, 56);
    expect(tester.getSize(find.byType(AppRadioTile)).height, 64);
    expect(tester.getSize(find.byType(AppRadio)), const Size(24, 24));
    expect(tester.getSize(find.byType(AppFilledButton)).height, 44);
    expect(tester.getSize(find.byType(AppTextButton)).height, 44);
  });

  testWidgets('chip icons end 28px into the pill and the label follows', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppChip(icon: AppIconKind.filter, label: 'Filtri', onTap: () {}),
            AppChip(
              icon: AppIconKind.sort,
              label: 'Ordina',
              labelGap: 0,
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    final filter = tester.getRect(find.byType(AppIcon).at(0));
    final sort = tester.getRect(find.byType(AppIcon).at(1));
    expect(filter.size, const Size(20, 20));
    expect(sort.size, const Size(24, 24));
    expect(filter.left, 8);
    expect(sort.left, 4);
    expect(filter.right, 28);
    expect(sort.right, 28);
    expect(tester.getRect(find.text('Filtri')).left, 30);
    expect(tester.getRect(find.text('Ordina')).left, 28);
  });

  testWidgets('product card image keeps the 164:195 box', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: SizedBox(
          width: 164,
          child: AppProductCard(
            title: 'Nike - Revolution 6 Next Nature Triple Black',
            merchant: 'Pittarello',
            fullPrice: '85,00€ or',
            installments: '3 installments of €28,33',
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppProductImage)), const Size(164, 195));
  });
}
