import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/subcategory_model.dart';

class SubcategoryDto {
  const SubcategoryDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryId,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String categoryId;
  final int sortOrder;

  factory SubcategoryDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubcategoryDto(
      id: doc.id,
      name: data['name'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
      categoryId: data['category_id'] as String? ?? '',
      sortOrder: data['sort_order'] as int? ?? 0,
    );
  }

  SubcategoryModel toDomain() => SubcategoryModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        sortOrder: sortOrder,
      );
}
