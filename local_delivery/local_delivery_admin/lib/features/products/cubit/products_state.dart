import 'package:equatable/equatable.dart';

import '../../categories/domain/models/category_model.dart';
import '../../subcategories/domain/models/subcategory_model.dart';
import '../domain/models/product_model.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  const ProductsLoaded({
    required this.products,
    required this.categories,
    required this.subcategories,
    this.selectedCategory,
    this.selectedSubcategory,
  });

  final List<ProductModel> products;
  final List<CategoryModel> categories;

  /// Subcategories filtered by [selectedCategory] for the filter dropdown.
  final List<SubcategoryModel> subcategories;

  final String? selectedCategory;
  final String? selectedSubcategory;

  @override
  List<Object?> get props =>
      [products, categories, subcategories, selectedCategory, selectedSubcategory];
}

class ProductsError extends ProductsState {
  const ProductsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ProductActionInProgress extends ProductsState {
  const ProductActionInProgress({
    required this.products,
    required this.categories,
    required this.subcategories,
    this.selectedCategory,
    this.selectedSubcategory,
  });

  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<SubcategoryModel> subcategories;
  final String? selectedCategory;
  final String? selectedSubcategory;

  @override
  List<Object?> get props =>
      [products, categories, subcategories, selectedCategory, selectedSubcategory];
}

class ProductActionSuccess extends ProductsState {
  const ProductActionSuccess({
    required this.products,
    required this.categories,
    required this.subcategories,
    required this.message,
    this.selectedCategory,
    this.selectedSubcategory,
  });

  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<SubcategoryModel> subcategories;
  final String message;
  final String? selectedCategory;
  final String? selectedSubcategory;

  @override
  List<Object?> get props =>
      [products, categories, subcategories, selectedCategory, selectedSubcategory, message];
}

class ProductActionError extends ProductsState {
  const ProductActionError({
    required this.products,
    required this.categories,
    required this.subcategories,
    required this.message,
    this.selectedCategory,
    this.selectedSubcategory,
  });

  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<SubcategoryModel> subcategories;
  final String message;
  final String? selectedCategory;
  final String? selectedSubcategory;

  @override
  List<Object?> get props =>
      [products, categories, subcategories, selectedCategory, selectedSubcategory, message];
}
