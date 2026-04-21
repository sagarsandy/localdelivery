import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/subcategory_model.dart';

class SubcategoryDto {
  const SubcategoryDto({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
  });

  final String id;
  final String title;
  final String image;
  final String category;

  factory SubcategoryDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubcategoryDto(
      id: doc.id,
      title: data['title'] as String? ?? '',
      image: data['image'] as String? ?? '',
      category: data['category'] as String? ?? '',
    );
  }

  SubcategoryModel toDomain() => SubcategoryModel(
        id: id,
        title: title,
        image: image,
        category: category,
      );

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'image': image,
        'category': category,
      };
}
