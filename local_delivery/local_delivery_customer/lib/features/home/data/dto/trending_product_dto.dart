import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/trending_product_model.dart';

class TrendingProductDto {
  const TrendingProductDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;

  factory TrendingProductDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrendingProductDto(
      id: doc.id,
      name: data['name'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  TrendingProductModel toDomain() => TrendingProductModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        price: price,
      );
}
