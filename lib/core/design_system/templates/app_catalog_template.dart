import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/templates/app_collapsing_title.dart';

// Scroll behaviour follows the Scalapay app: the large title contracts into a
// compact centred bar, the search bar scrolls away with the content and the
// chips stay pinned under the bar.
class AppCatalogTemplate extends StatelessWidget {
  const AppCatalogTemplate({
    required this.title,
    required this.searchBar,
    required this.chips,
    required this.body,
    super.key,
    this.controller,
  });

  final String title;
  final Widget searchBar;
  final List<Widget> chips;
  final List<Widget> body;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Scaffold(
      backgroundColor: palette.grayscale100,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: controller,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            AppCollapsingTitle(title: title),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
                child: searchBar,
              ),
            ),
            PinnedHeaderSliver(
              child: ColoredBox(
                color: palette.grayscale100,
                child: _ChipsRow(chips: chips),
              ),
            ),
            ...body,
          ],
        ),
      ),
    );
  }
}

class _ChipsRow extends StatelessWidget {
  const _ChipsRow({required this.chips});

  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    // Figma: 32px pills 13px from the row edges (58px row).
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x13,
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: AppSpacing.x8,
        runSpacing: AppSpacing.x8,
        children: chips,
      ),
    );
  }
}
