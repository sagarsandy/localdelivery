import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/category_model.dart';

class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String imageUrl;

  factory CategoryDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryDto(
      id: doc.id,
      name: data['title'] as String? ?? '',
      imageUrl: data['image'] as String? ?? '',
    );
  }

  CategoryModel toDomain() => CategoryModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
      );
}
