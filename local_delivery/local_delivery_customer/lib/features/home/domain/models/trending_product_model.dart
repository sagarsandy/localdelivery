import 'package:equatable/equatable.dart';

class TrendingProductModel extends Equatable {
  const TrendingProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.units,
    required this.isAvailable,
    required this.inStock,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String units;
  final bool isAvailable;
  final bool inStock;

  @override
  List<Object?> get props => [id, name, price];
}
