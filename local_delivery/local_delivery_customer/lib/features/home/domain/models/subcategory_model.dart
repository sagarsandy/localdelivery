import 'package:equatable/equatable.dart';

class SubcategoryModel extends Equatable {
  const SubcategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryId,
    this.sortOrder = 0,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String categoryId;
  final int sortOrder;

  @override
  List<Object?> get props => [id, name, categoryId];
}
