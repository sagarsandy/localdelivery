import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/subcategory_model.dart';

class SubcategoryDto {
  const SubcategoryDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryId,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String categoryId;

  factory SubcategoryDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubcategoryDto(
      id: doc.id,
      name: data['title'] as String? ?? '',
      imageUrl: data['image'] as String? ?? '',
      categoryId: data['category'] as String? ?? '',
    );
  }

  SubcategoryModel toDomain() => SubcategoryModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
      );
}
