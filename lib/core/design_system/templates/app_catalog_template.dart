import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_spacing.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_typography.dart';

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
    return Scaffold(
      backgroundColor: context.appPalette.grayscale100,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: controller,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(child: _Header(title: title)),
            // The title scrolls away; search and chips stay reachable.
            PinnedHeaderSliver(
              child: _RevealBoundary(
                child: _Controls(searchBar: searchBar, chips: chips),
              ),
            ),
            ...body,
          ],
        ),
      ),
    );
  }
}

// The pinned controls are always visible, so a request to reveal one of them
// (focusing the search field, accessibility focus) must not move the list.
class _RevealBoundary extends SingleChildRenderObjectWidget {
  const _RevealBoundary({required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderRevealBoundary();
}

class _RenderRevealBoundary extends RenderProxyBox {
  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {}
}

class _Controls extends StatelessWidget {
  const _Controls({required this.searchBar, required this.chips});

  final Widget searchBar;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appPalette.grayscale100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
            child: searchBar,
          ),
          _ChipsRow(chips: chips),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x26,
        AppSpacing.x57,
        AppSpacing.x26,
        AppSpacing.x10,
      ),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: AppTypography.h2(
            color: context.appPalette.typographyAllHeaders,
          ),
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
