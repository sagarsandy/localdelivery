import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/product_model.dart';

class ProductDto {
  const ProductDto({
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
  final double? originalPrice;
  final int quantity;
  final String units;
  final bool isAvailable;
  final bool inStock;
  final String subcategoryId;
  final String? description;

  factory ProductDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductDto(
      id: doc.id,
      name: data['title'] as String? ?? data['name'] as String? ?? '',
      imageUrl: data['image'] as String? ?? data['imageUrl'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (data['originalPrice'] as num?)?.toDouble(),
      quantity: data['quantity'] as int? ?? 0,
      units: data['units'] as String? ?? '',
      isAvailable: data['isAvailable'] as bool? ?? true,
      inStock: data['inStock'] as bool? ?? true,
      subcategoryId: data['subcategoryId'] as String? ?? '',
      description: data['description'] as String?,
    );
  }

  ProductModel toDomain() => ProductModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        price: price,
        originalPrice: originalPrice,
        quantity: quantity,
        units: units,
        isAvailable: isAvailable,
        inStock: inStock,
        subcategoryId: subcategoryId,
        description: description,
      );
}
