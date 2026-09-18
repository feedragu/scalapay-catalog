import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/app_design_system.dart';
import 'package:scalapay_catalog/features/catalog/domain/entities/price_range.dart';
import 'package:scalapay_catalog/features/catalog/presentation/presenters/price_input.dart';
import 'package:scalapay_catalog/l10n/l10n.dart';

Future<PriceRange?> showFilterSheet(
  BuildContext context, {
  required PriceRange initial,
}) {
  return showAppBottomSheet<PriceRange>(
    context,
    builder: (_) => FilterSheet(initial: initial),
  );
}

// Draft values stay in the sheet: nothing reaches the catalog until
// "Mostra risultati" pops the range.
class FilterSheet extends StatefulWidget {
  const FilterSheet({required this.initial, super.key});

  final PriceRange initial;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final _form = GlobalKey<FormState>();
  late final _min = TextEditingController(
    text: PriceInput.format(widget.initial.min),
  );
  late final _max = TextEditingController(
    text: PriceInput.format(widget.initial.max),
  );
  // Errors appear on the first failed submit, then follow every edit.
  var _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBottomSheetTemplate(
      title: l10n.filtersTitle,
      closeLabel: l10n.close,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          0,
          AppSpacing.x16,
          AppSpacing.x4,
        ),
        child: Form(
          key: _form,
          autovalidateMode: _autovalidate,
          child: AppSheetSection(
            title: l10n.priceRangeTitle,
            child: _fields(l10n),
          ),
        ),
      ),
      actions: AppSheetActions(
        secondaryLabel: l10n.clearAll,
        onSecondary: () => Navigator.of(context).pop(PriceRange.none),
        primaryLabel: l10n.showResults,
        onPrimary: _apply,
      ),
    );
  }

  Widget _fields(AppLocalizations l10n) => AppPriceRangeFields(
    minController: _min,
    maxController: _max,
    minLabel: l10n.priceMin,
    maxLabel: l10n.priceMax,
    minValidator: _validateAmount,
    maxValidator: _validateMax,
    inputFormatters: PriceInput.inputFormatters,
    onSubmitted: _apply,
  );

  String? _validateAmount(String? text) =>
      PriceInput.parse(text ?? '') is InvalidPrice
      ? context.l10n.invalidPriceNumber
      : null;

  String? _validateMax(String? text) {
    final invalid = _validateAmount(text);
    if (invalid != null) return invalid;
    return _range(max: text).isValid ? null : context.l10n.invalidPriceRange;
  }

  PriceRange _range({String? max}) =>
      PriceRange(min: _amountOf(_min.text), max: _amountOf(max ?? _max.text));

  static double? _amountOf(String text) {
    final input = PriceInput.parse(text);
    if (input is PriceAmount) return input.value;
    return null;
  }

  void _apply() {
    if (!_form.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }
    Navigator.of(context).pop(_range());
  }
}
