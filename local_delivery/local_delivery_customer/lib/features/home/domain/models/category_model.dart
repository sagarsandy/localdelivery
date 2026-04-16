import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.sortOrder = 0,
  });

  final String id;
  final String name;
  final String imageUrl;
  final int sortOrder;

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
        id: map['id'] as String,
        name: map['name'] as String,
        imageUrl: map['image_url'] as String? ?? '',
        sortOrder: map['sort_order'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [id, name];
}
