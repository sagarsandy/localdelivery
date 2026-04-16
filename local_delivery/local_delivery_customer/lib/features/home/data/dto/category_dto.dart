import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/category_model.dart';

class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String imageUrl;
  final int sortOrder;

  factory CategoryDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryDto(
      id: doc.id,
      name: data['name'] as String,
      imageUrl: data['image_url'] as String? ?? '',
      sortOrder: data['sort_order'] as int? ?? 0,
    );
  }

  CategoryModel toDomain() => CategoryModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        sortOrder: sortOrder,
      );
}
