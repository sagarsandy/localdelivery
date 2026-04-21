import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.id,
    required this.title,
    required this.image,
  });

  final String id;
  final String title;
  final String image;

  @override
  List<Object?> get props => [id, title, image];
}
