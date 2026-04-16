import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/trending_product_model.dart';

class TrendingProductDto {
  const TrendingProductDto({
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

  factory TrendingProductDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrendingProductDto(
      id: doc.id,
      name: data['title'] as String? ?? '',
      imageUrl: data['image'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      quantity: data['quantity'] as int? ?? 0,
      units: data['units'] as String? ?? '',
      isAvailable: data['isAvailable'] as bool? ?? true,
      inStock: data['inStock'] as bool? ?? true,
    );
  }

  TrendingProductModel toDomain() => TrendingProductModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
        units: units,
        isAvailable: isAvailable,
        inStock: inStock,
      );
}
