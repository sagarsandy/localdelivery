import 'package:equatable/equatable.dart';

class SubcategoryModel extends Equatable {
  const SubcategoryModel({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
  });

  final String id;
  final String title;
  final String image;

  /// Lowercase category title as stored in Firestore.
  final String category;

  @override
  List<Object?> get props => [id, title, image, category];
}
