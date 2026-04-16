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
    this._getFreshSubcategoriesUseCase,
    this._getTrendingProductsUseCase,
  ) : super(HomeInitial());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetFreshSubcategoriesUseCase _getFreshSubcategoriesUseCase;
  final GetTrendingProductsUseCase _getTrendingProductsUseCase;

  Future<void> loadHome() async {
    emit(HomeLoading());

    final categoriesResult = await _getCategoriesUseCase.getCategories();
    final trendingResult = await _getTrendingProductsUseCase.getTrendingProducts();

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

    categoriesResult.fold((_) {}, (data) => categories = data);
    trendingResult.fold((_) {}, (data) => trending = data);

    // Find "fresh" category and load its subcategories
    final freshCategoryId = categories
        .where((c) => c.name.toLowerCase() == 'fresh')
        .map((c) => c.id)
        .firstOrNull;

    List<SubcategoryModel> freshSubcategories = [];
    if (freshCategoryId != null) {
      final subcatResult = await _getFreshSubcategoriesUseCase.getSubcategories(
        categoryId: freshCategoryId,
      );
      subcatResult.fold((_) {}, (data) => freshSubcategories = data);
    }

    emit(HomeLoaded(
      categories: categories,
      freshSubcategories: freshSubcategories,
      trendingProducts: trending,
    ));
  }
}
