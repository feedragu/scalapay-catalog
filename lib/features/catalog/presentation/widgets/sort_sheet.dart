import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/product_sort.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/product_sort_presenter.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

Future<ProductSort?> showSortSheet(
  BuildContext context, {
  required ProductSort current,
}) {
  return showAppBottomSheet<ProductSort>(
    context,
    builder: (_) => SortSheet(current: current),
  );
}

class SortSheet extends StatelessWidget {
  const SortSheet({required this.current, super.key});

  final ProductSort current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = ProductSortPresenter.options(l10n);
    final selectedIndex = options.indexWhere((o) => o.sort == current);
    return AppBottomSheetTemplate(
      title: l10n.sortTitle,
      closeLabel: l10n.close,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          0,
          AppSpacing.x16,
          AppSpacing.x16,
        ),
        child: AppSortOptionList(
          labels: [for (final option in options) option.label],
          selectedIndex: selectedIndex < 0 ? null : selectedIndex,
          // Re-selecting the active sort clears it (toggleable radio): the
          // design has no explicit "relevance" entry.
          onSelected: (index) => Navigator.of(context).pop(
            index == selectedIndex
                ? ProductSort.relevance
                : options[index].sort,
          ),
        ),
      ),
    );
  }
}
