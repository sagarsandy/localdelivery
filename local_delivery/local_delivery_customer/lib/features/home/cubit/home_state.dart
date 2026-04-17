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
    required this.subcategoriesByCategory,
    required this.trendingProducts,
  });

  final List<CategoryModel> categories;
  /// Key = category name lowercased (e.g. 'fresh', 'drinks')
  final Map<String, List<SubcategoryModel>> subcategoriesByCategory;
  final List<TrendingProductModel> trendingProducts;

  HomeLoaded copyWith({
    List<CategoryModel>? categories,
    Map<String, List<SubcategoryModel>>? subcategoriesByCategory,
    List<TrendingProductModel>? trendingProducts,
  }) =>
      HomeLoaded(
        categories: categories ?? this.categories,
        subcategoriesByCategory:
            subcategoriesByCategory ?? this.subcategoriesByCategory,
        trendingProducts: trendingProducts ?? this.trendingProducts,
      );

  @override
  List<Object?> get props => [categories, subcategoriesByCategory, trendingProducts];
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
