import 'package:equatable/equatable.dart';
import '../domain/models/category_model.dart';
import '../domain/models/subcategory_model.dart';
import '../domain/models/trending_product_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.categories,
    required this.freshSubcategories,
    required this.trendingProducts,
  });

  final List<CategoryModel> categories;
  final List<SubcategoryModel> freshSubcategories;
  final List<TrendingProductModel> trendingProducts;

  HomeLoaded copyWith({
    List<CategoryModel>? categories,
    List<SubcategoryModel>? freshSubcategories,
    List<TrendingProductModel>? trendingProducts,
  }) =>
      HomeLoaded(
        categories: categories ?? this.categories,
        freshSubcategories: freshSubcategories ?? this.freshSubcategories,
        trendingProducts: trendingProducts ?? this.trendingProducts,
      );

  @override
  List<Object?> get props => [categories, freshSubcategories, trendingProducts];
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
