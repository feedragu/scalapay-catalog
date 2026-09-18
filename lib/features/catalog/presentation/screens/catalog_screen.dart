import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_query.dart';
import 'package:scalapay_catalog/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/price_range_presenter.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/product_sort_presenter.dart';
import 'package:scalapay_catalog/features/catalog/presentation/widgets/catalog_body.dart';
import 'package:scalapay_catalog/features/catalog/presentation/widgets/filter_sheet.dart';
import 'package:scalapay_catalog/features/catalog/presentation/widgets/sort_sheet.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const _loadMoreThreshold = 400.0;

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreIfNearEnd);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // A new query replaces the list, so it restarts from the top; appended
  // pages keep the position.
  void _backToTop() {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<CatalogBloc>();
    return BlocListener<CatalogBloc, CatalogState>(
      listenWhen: (previous, current) =>
          current.query.page == 1 && current.query != previous.query,
      listener: (_, _) => _backToTop(),
      child: _buildTemplate(context, bloc, l10n),
    );
  }

  Widget _buildTemplate(
    BuildContext context,
    CatalogBloc bloc,
    AppLocalizations l10n,
  ) {
    return AppCatalogTemplate(
      title: l10n.catalogTitle,
      controller: _scrollController,
      searchBar: AppSearchBar(
        controller: _searchController,
        hintText: l10n.searchHint,
        searchLabel: l10n.searchAction,
        onChanged: (text) => bloc.add(CatalogSearchChanged(text)),
        onSubmitted: (text) => bloc.add(CatalogSearchSubmitted(text)),
      ),
      chips: [
        _QueryChip(
          icon: AppIconKind.filter,
          label: l10n.filtersChip,
          describe: (query) =>
              PriceRangePresenter.describe(query.priceRange, l10n),
          onTap: () => _openFilters(context),
        ),
        _QueryChip(
          icon: AppIconKind.sort,
          label: l10n.sortChip,
          labelGap: 0,
          describe: (query) => ProductSortPresenter.label(query.sort, l10n),
          onTap: () => _openSort(context),
        ),
      ],
      body: [
        BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) => CatalogBody(state: state),
        ),
      ],
    );
  }

  // After a failed page only the inline "Riprova" retries, so a user parked
  // at the end of the list does not hammer a failing backend.
  void _loadMoreIfNearEnd() {
    final bloc = context.read<CatalogBloc>();
    final state = bloc.state;
    final position = _scrollController.position;
    final nearEnd =
        position.pixels >= position.maxScrollExtent - _loadMoreThreshold;
    if (nearEnd &&
        state.hasMore &&
        !state.isLoadingMore &&
        !state.loadMoreFailed) {
      bloc.add(const CatalogNextPageRequested());
    }
  }

  Future<void> _openFilters(BuildContext context) async {
    final bloc = context.read<CatalogBloc>();
    final range = await showFilterSheet(
      context,
      initial: bloc.state.query.priceRange,
    );
    if (range != null) bloc.add(CatalogFiltersApplied(range));
  }

  Future<void> _openSort(BuildContext context) async {
    final bloc = context.read<CatalogBloc>();
    final sort = await showSortSheet(context, current: bloc.state.query.sort);
    if (sort != null) bloc.add(CatalogSortChanged(sort));
  }
}

// Active (with its spoken description) when [describe] returns a value;
// rebuilds only when that description changes.
class _QueryChip extends StatelessWidget {
  const _QueryChip({
    required this.icon,
    required this.label,
    required this.describe,
    required this.onTap,
    this.labelGap = AppSpacing.x2,
  });

  final AppIconKind icon;
  final String label;
  final String? Function(ProductQuery query) describe;
  final VoidCallback onTap;
  final double labelGap;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CatalogBloc, CatalogState, String?>(
      selector: (state) => describe(state.query),
      builder: (context, description) => AppChip(
        icon: icon,
        label: label,
        labelGap: labelGap,
        badgeCount: description == null ? null : 1,
        activeDescription: description,
        onTap: onTap,
      ),
    );
  }
}
