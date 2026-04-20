import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/use_cases/get_products_use_case.dart';
import 'product_listing_state.dart';

class ProductListingCubit extends Cubit<ProductListingState> {
  ProductListingCubit(this._getProductsUseCase)
      : super(const ProductListingInitial());

  final GetProductsUseCase _getProductsUseCase;

  Future<void> loadProducts({required String subcategoryId}) async {
    emit(const ProductListingLoading());
    final result =
        await _getProductsUseCase.getProducts(subcategoryId: subcategoryId);
    result.fold(
      (failure) => emit(ProductListingError(message: failure.message)),
      (products) => emit(ProductListingLoaded(products: products)),
    );
  }
}
