import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';

// The two-column Figma grid. Not a SliverGrid: that needs one aspect ratio
// (or extent) for every card, while here only the image is fixed-ratio and
// the text block sizes itself. Rows are built lazily and size to their
// tallest card, so two-line titles and large text scales do not clip.
class AppProductGrid extends StatelessWidget {
  const AppProductGrid({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  static const columns = 2;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.gridPadding),
      sliver: SliverList.builder(
        itemCount: (itemCount / columns).ceil(),
        itemBuilder: (context, row) => _GridRow(
          firstIndex: row * columns,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}

class _GridRow extends StatelessWidget {
  const _GridRow({
    required this.firstIndex,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int firstIndex;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var column = 0; column < AppProductGrid.columns; column++) ...[
          if (column > 0) const SizedBox(width: AppSizes.gridGutter),
          Expanded(
            child: firstIndex + column < itemCount
                ? itemBuilder(context, firstIndex + column)
                : const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }
}
