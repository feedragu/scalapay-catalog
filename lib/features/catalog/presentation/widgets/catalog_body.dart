import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/catalog_error_presenter.dart';
import 'package:scalapay_catalog/features/catalog/presentation/widgets/product_card_item.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

class CatalogBody extends StatelessWidget {
  const CatalogBody({required this.state, super.key});

  final CatalogState state;

  static const skeletonCount = 6;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return switch (state.status) {
      CatalogStatus.initial => _message(
        AppStateMessage(
          icon: Icons.search,
          title: l10n.idleTitle,
          message: l10n.idleMessage,
        ),
      ),
      CatalogStatus.loading => _LoadingGrid(label: l10n.loadingProducts),
      CatalogStatus.failure => _message(
        AppStateMessage(
          icon: Icons.error_outline,
          title: l10n.errorTitle,
          message: CatalogErrorPresenter.message(l10n, state.error!),
          actionLabel: l10n.retry,
          onAction: () =>
              context.read<CatalogBloc>().add(const CatalogRetryRequested()),
        ),
      ),
      CatalogStatus.success when state.isEmpty => _message(
        AppStateMessage(
          icon: Icons.search_off,
          title: l10n.emptyTitle,
          message: l10n.emptyMessage,
        ),
      ),
      CatalogStatus.success => _ResultsGrid(state: state),
    };
  }

  Widget _message(Widget child) =>
      SliverFillRemaining(hasScrollBody: false, child: child);
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SliverSemantics(
      liveRegion: true,
      label: label,
      sliver: AppProductGrid(
        itemCount: CatalogBody.skeletonCount,
        itemBuilder: (_, _) => const AppProductCardSkeleton(),
      ),
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({required this.state});

  final CatalogState state;

  @override
  Widget build(BuildContext context) {
    final products = state.products;
    return SliverMainAxisGroup(
      slivers: [
        // Announces the count when results arrive or a page is appended.
        SliverSemantics(
          liveRegion: true,
          label: context.l10n.resultsCount(products.length),
          sliver: AppProductGrid(
            itemCount: products.length,
            itemBuilder: (_, index) => ProductCardItem(
              key: ValueKey(products[index].id),
              product: products[index],
            ),
          ),
        ),
        SliverToBoxAdapter(child: _LoadMoreFooter(state: state)),
      ],
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({required this.state});

  final CatalogState state;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom + AppSpacing.x16;
    if (state.isLoadingMore) {
      return Padding(
        padding: EdgeInsets.only(top: AppSpacing.x16, bottom: bottom),
        child: Center(
          child: CircularProgressIndicator(
            semanticsLabel: context.l10n.loadingProducts,
          ),
        ),
      );
    }
    if (state.loadMoreFailed) {
      return Padding(
        padding: EdgeInsets.only(top: AppSpacing.x8, bottom: bottom),
        child: const _LoadMoreRetry(),
      );
    }
    return SizedBox(height: bottom);
  }
}

class _LoadMoreRetry extends StatelessWidget {
  const _LoadMoreRetry();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            l10n.loadMoreFailed,
            style: AppTypography.p3Medium(
              color: context.appPalette.grayscale700,
            ),
          ),
        ),
        AppTextButton(
          label: l10n.retry,
          onPressed: () =>
              context.read<CatalogBloc>().add(const CatalogNextPageRequested()),
        ),
      ],
    );
  }
}
