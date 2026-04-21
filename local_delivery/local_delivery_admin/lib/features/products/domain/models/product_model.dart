import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.units,
    required this.inStock,
    required this.isAvailable,
  });

  final String id;
  final String title;
  final String description;
  final String image;

  /// Lowercase category title.
  final String category;

  /// Lowercase subcategory title.
  final String subcategory;

  final double price;
  final double originalPrice;
  final int quantity;
  final String units;
  final bool inStock;
  final bool isAvailable;

  @override
  List<Object?> get props => [
        id, title, description, image, category, subcategory,
        price, originalPrice, quantity, units, inStock, isAvailable,
      ];
}
