import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/product_model.dart';

class ProductDto {
  const ProductDto({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.categoryId,
    required this.isAvailable,
    required this.sortOrder,
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

  factory ProductDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductDto(
      id: doc.id,
      storeId: data['store_id'] as String,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (data['original_price'] as num?)?.toDouble(),
      categoryId: data['category_id'] as String? ?? '',
      isAvailable: data['is_available'] as bool? ?? true,
      sortOrder: data['sort_order'] as int? ?? 0,
    );
  }

  factory ProductDto.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductDto(
      id: doc.id,
      storeId: data['store_id'] as String,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (data['original_price'] as num?)?.toDouble(),
      categoryId: data['category_id'] as String? ?? '',
      isAvailable: data['is_available'] as bool? ?? true,
      sortOrder: data['sort_order'] as int? ?? 0,
    );
  }

  ProductModel toDomain() => ProductModel(
        id: id,
        storeId: storeId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        price: price,
        originalPrice: originalPrice,
        categoryId: categoryId,
        isAvailable: isAvailable,
        sortOrder: sortOrder,
      );
}
