import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/store_model.dart';

class StoreDto {
  const StoreDto({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTimeMinutes,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isOpen,
    required this.categories,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTimeMinutes;
  final double deliveryFee;
  final double minimumOrder;
  final bool isOpen;
  final List<String> categories;

  factory StoreDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoreDto(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      deliveryTimeMinutes: data['delivery_time_minutes'] as int? ?? 30,
      deliveryFee: (data['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      minimumOrder: (data['minimum_order'] as num?)?.toDouble() ?? 0.0,
      isOpen: data['is_open'] as bool? ?? true,
      categories: List<String>.from(data['categories'] as List? ?? []),
    );
  }

  factory StoreDto.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoreDto(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      deliveryTimeMinutes: data['delivery_time_minutes'] as int? ?? 30,
      deliveryFee: (data['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      minimumOrder: (data['minimum_order'] as num?)?.toDouble() ?? 0.0,
      isOpen: data['is_open'] as bool? ?? true,
      categories: List<String>.from(data['categories'] as List? ?? []),
    );
  }

  StoreModel toDomain() => StoreModel(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        rating: rating,
        deliveryTimeMinutes: deliveryTimeMinutes,
        deliveryFee: deliveryFee,
        minimumOrder: minimumOrder,
        isOpen: isOpen,
        categories: categories,
      );
}
