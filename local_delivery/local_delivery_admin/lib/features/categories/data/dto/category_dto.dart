import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/category_model.dart';

class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.title,
    required this.image,
  });

  final String id;
  final String title;
  final String image;

  factory CategoryDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryDto(
      id: doc.id,
      title: data['title'] as String? ?? '',
      image: data['image'] as String? ?? '',
    );
  }

  CategoryModel toDomain() => CategoryModel(id: id, title: title, image: image);

  Map<String, dynamic> toFirestore() => {'title': title, 'image': image};
}
