import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.categoryId,
    required this.isAvailable,
    this.sortOrder = 0,
  });

  final String id;
  final String storeId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String categoryId;
  final bool isAvailable;
  final int sortOrder;

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'] as String,
        storeId: map['store_id'] as String,
        name: map['name'] as String,
        description: map['description'] as String? ?? '',
        imageUrl: map['image_url'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        originalPrice: (map['original_price'] as num?)?.toDouble(),
        categoryId: map['category_id'] as String? ?? '',
        isAvailable: map['is_available'] as bool? ?? true,
        sortOrder: map['sort_order'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'store_id': storeId,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'price': price,
        'original_price': originalPrice,
        'category_id': categoryId,
        'is_available': isAvailable,
        'sort_order': sortOrder,
      };

  @override
  List<Object?> get props => [id, storeId, name, price, isAvailable];
}
