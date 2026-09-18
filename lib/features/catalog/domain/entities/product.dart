import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.merchant,
    required this.price,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String merchant;
  final double price;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, title, merchant, price, imageUrl];
}
