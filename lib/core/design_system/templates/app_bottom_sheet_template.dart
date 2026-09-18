import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/molecules/app_sheet_header.dart';

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: builder,
  );
}

class AppBottomSheetTemplate extends StatelessWidget {
  const AppBottomSheetTemplate({
    required this.title,
    required this.closeLabel,
    required this.body,
    super.key,
    this.actions,
  });

  final String title;
  final String closeLabel;
  final Widget body;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSheetHeader(
              title: title,
              closeLabel: closeLabel,
              onClose: () => Navigator.of(context).pop(),
            ),
            Flexible(child: SingleChildScrollView(child: body)),
            ?actions,
          ],
        ),
      ),
    );
  }
}
