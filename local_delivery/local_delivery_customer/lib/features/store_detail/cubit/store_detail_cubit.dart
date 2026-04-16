import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/use_cases/get_store_detail_use_case.dart';
import '../domain/use_cases/get_store_products_use_case.dart';
import 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  StoreDetailCubit(this._getStoreDetailUseCase, this._getStoreProductsUseCase)
      : super(StoreDetailInitial());

  final GetStoreDetailUseCase _getStoreDetailUseCase;
  final GetStoreProductsUseCase _getStoreProductsUseCase;

  Future<void> loadStoreDetail(String storeId) async {
    emit(StoreDetailLoading());

    final storeResult = await _getStoreDetailUseCase.getDetail(storeId: storeId);
    storeResult.fold(
      (failure) => emit(StoreDetailError(failure.message)),
      (store) async {
        final productsResult =
            await _getStoreProductsUseCase.getProducts(storeId: storeId);
        productsResult.fold(
          (failure) => emit(StoreDetailError(failure.message)),
          (products) => emit(
            StoreDetailLoaded(store: store, products: products),
          ),
        );
      },
    );
  }

  Future<void> filterByCategory(String? categoryId) async {
    final currentState = state;
    if (currentState is! StoreDetailLoaded) return;

    final productsResult = await _getStoreProductsUseCase.getProducts(
      storeId: currentState.store.id,
      categoryId: categoryId,
    );
    productsResult.fold(
      (failure) => emit(StoreDetailError(failure.message)),
      (products) => emit(currentState.copyWith(
        products: products,
        selectedCategoryId: categoryId,
      )),
    );
  }
}
