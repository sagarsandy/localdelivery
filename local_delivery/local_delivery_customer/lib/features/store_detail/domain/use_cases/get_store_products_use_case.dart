import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/product_model.dart';
import '../repositories/store_detail_repository.dart';

class GetStoreProductsUseCase {
  const GetStoreProductsUseCase(this._repository);
  final StoreDetailRepository _repository;

  Future<Either<Failure, List<ProductModel>>> getProducts({
    required String storeId,
    String? categoryId,
  }) =>
      _repository.getStoreProducts(storeId: storeId, categoryId: categoryId);
}
