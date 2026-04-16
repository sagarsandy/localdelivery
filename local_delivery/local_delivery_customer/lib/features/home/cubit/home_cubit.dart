import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/use_cases/get_stores_use_case.dart';
import '../domain/use_cases/get_categories_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getStoresUseCase, this._getCategoriesUseCase)
      : super(HomeInitial());

  final GetStoresUseCase _getStoresUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> loadHome() async {
    emit(HomeLoading());
    final categoriesResult = await _getCategoriesUseCase.getCategories();
    final storesResult = await _getStoresUseCase.getStores();

    categoriesResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (categories) => storesResult.fold(
        (failure) => emit(HomeError(failure.message)),
        (stores) => emit(HomeLoaded(stores: stores, categories: categories)),
      ),
    );
  }

  Future<void> filterByCategory(String? categoryId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final storesResult = await _getStoresUseCase.getStores(categoryId: categoryId);
    storesResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (stores) => emit(currentState.copyWith(
        stores: stores,
        selectedCategoryId: categoryId,
      )),
    );
  }
}
