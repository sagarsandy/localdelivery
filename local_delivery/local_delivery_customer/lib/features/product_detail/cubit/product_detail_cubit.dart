import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/use_cases/get_product_detail_use_case.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._getProductDetailUseCase)
      : super(ProductDetailInitial());

  final GetProductDetailUseCase _getProductDetailUseCase;

  Future<void> loadProductDetail(String productId) async {
    emit(ProductDetailLoading());
    final result = await _getProductDetailUseCase.getDetail(productId: productId);
    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }
}
