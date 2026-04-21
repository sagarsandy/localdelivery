import 'package:equatable/equatable.dart';
import '../../categories/domain/models/category_model.dart';
import '../domain/models/subcategory_model.dart';

abstract class SubcategoriesState extends Equatable {
  const SubcategoriesState();
  @override
  List<Object?> get props => [];
}

class SubcategoriesInitial extends SubcategoriesState {}

class SubcategoriesLoading extends SubcategoriesState {}

class SubcategoriesLoaded extends SubcategoriesState {
  const SubcategoriesLoaded({
    required this.subcategories,
    required this.categories,
    this.selectedCategory,
  });
  final List<SubcategoryModel> subcategories;
  final List<CategoryModel> categories;

  /// Lowercase category title currently selected for filtering; null = all.
  final String? selectedCategory;

  @override
  List<Object?> get props => [subcategories, categories, selectedCategory];
}

class SubcategoriesError extends SubcategoriesState {
  const SubcategoriesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class SubcategoryActionInProgress extends SubcategoriesState {
  const SubcategoryActionInProgress({
    required this.subcategories,
    required this.categories,
    this.selectedCategory,
  });
  final List<SubcategoryModel> subcategories;
  final List<CategoryModel> categories;
  final String? selectedCategory;

  @override
  List<Object?> get props => [subcategories, categories, selectedCategory];
}

class SubcategoryActionSuccess extends SubcategoriesState {
  const SubcategoryActionSuccess({
    required this.subcategories,
    required this.categories,
    required this.message,
    this.selectedCategory,
  });
  final List<SubcategoryModel> subcategories;
  final List<CategoryModel> categories;
  final String? selectedCategory;
  final String message;

  @override
  List<Object?> get props =>
      [subcategories, categories, selectedCategory, message];
}

class SubcategoryActionError extends SubcategoriesState {
  const SubcategoryActionError({
    required this.subcategories,
    required this.categories,
    required this.message,
    this.selectedCategory,
  });
  final List<SubcategoryModel> subcategories;
  final List<CategoryModel> categories;
  final String? selectedCategory;
  final String message;

  @override
  List<Object?> get props =>
      [subcategories, categories, selectedCategory, message];
}
