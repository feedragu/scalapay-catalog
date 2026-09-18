import 'package:equatable/equatable.dart';

class PriceRange extends Equatable {
  const PriceRange({this.min, this.max});

  static const none = PriceRange();

  final double? min;
  final double? max;

  bool get isEmpty => min == null && max == null;

  bool get isValid {
    final min = this.min;
    final max = this.max;
    if (min != null && min < 0) return false;
    if (max != null && max < 0) return false;
    if (min != null && max != null && min > max) return false;
    return true;
  }

  @override
  List<Object?> get props => [min, max];
}
