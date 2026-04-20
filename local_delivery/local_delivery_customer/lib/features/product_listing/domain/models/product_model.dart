import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.quantity,
    required this.units,
    required this.isAvailable,
    required this.inStock,
    required this.subcategoryId,
    this.description,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;

  /// MRP / original price. If present and greater than [price], shown
  /// as a struck-through price to communicate a discount to the user.
  final double? originalPrice;

  final int quantity;
  final String units;
  final bool isAvailable;
  final bool inStock;
  final String subcategoryId;
  final String? description;

  /// True when there is a meaningful discount to display.
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Whole-number percentage saved, e.g. 33 for "33% OFF".
  int get discountPercent => hasDiscount
      ? ((originalPrice! - price) / originalPrice! * 100).round()
      : 0;

  String _fmt(double v) => v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
  String get formattedPrice => '₹${_fmt(price)}';
  String get formattedOriginalPrice => hasDiscount ? '₹${_fmt(originalPrice!)}' : '';

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        price,
        originalPrice,
        quantity,
        units,
        isAvailable,
        inStock,
        subcategoryId,
        description,
      ];
}
