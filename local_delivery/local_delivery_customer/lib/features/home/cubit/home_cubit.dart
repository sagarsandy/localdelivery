import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/category_model.dart';
import '../domain/models/subcategory_model.dart';
import '../domain/models/trending_product_model.dart';
import '../domain/use_cases/get_categories_use_case.dart';
import '../domain/use_cases/get_fresh_subcategories_use_case.dart';
import '../domain/use_cases/get_trending_products_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._getCategoriesUseCase,
    this._getSubcategoriesUseCase,
    this._getTrendingProductsUseCase,
  ) : super(HomeInitial());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetSubcategoriesUseCase _getSubcategoriesUseCase;
  final GetTrendingProductsUseCase _getTrendingProductsUseCase;

  Future<void> loadHome() async {
    emit(HomeLoading());

    // Fetch categories and trending in parallel
    final results = await Future.wait([
      _getCategoriesUseCase.getCategories(),
      _getTrendingProductsUseCase.getTrendingProducts(),
    ]);

    final categoriesResult = results[0];
    final trendingResult = results[1];

    List<CategoryModel> categories = [];
    List<TrendingProductModel> trending = [];

    final categoriesFailure = categoriesResult.fold((f) => f, (_) => null);
    if (categoriesFailure != null) {
      emit(HomeError(categoriesFailure.message));
      return;
    }

    final trendingFailure = trendingResult.fold((f) => f, (_) => null);
    if (trendingFailure != null) {
      emit(HomeError(trendingFailure.message));
      return;
    }

    categoriesResult.fold(
        (_) {}, (data) => categories = data as List<CategoryModel>);
    trendingResult.fold(
        (_) {}, (data) => trending = data as List<TrendingProductModel>);

    // Fetch subcategories for each category in parallel — silently skip failures
    final subcategoryFutures = categories.map(
      (category) => _getSubcategoriesUseCase
          .getSubcategories(categoryId: category.name)
          .then((result) => MapEntry(
                category.name.toLowerCase(),
                result.fold((_) => <SubcategoryModel>[], (data) => data),
              )),
    );

    final subcategoryEntries = await Future.wait(subcategoryFutures);

    // Build map; exclude categories with zero subcategories
    final subcategoriesByCategory =
        Map<String, List<SubcategoryModel>>.fromEntries(
      subcategoryEntries.where((e) => e.value.isNotEmpty),
    );

    emit(HomeLoaded(
      categories: categories,
      subcategoriesByCategory: subcategoriesByCategory,
      trendingProducts: trending,
    ));
  }
}
