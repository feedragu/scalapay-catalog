import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_border_radius.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/molecules/app_radio_tile.dart';

class AppSortOptionList extends StatelessWidget {
  const AppSortOptionList({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appPalette.grayscale100,
      borderRadius: AppBorderRadius.cardAll,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++)
            AppRadioTile(
              label: labels[i],
              selected: i == selectedIndex,
              showDivider: i < labels.length - 1,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}
