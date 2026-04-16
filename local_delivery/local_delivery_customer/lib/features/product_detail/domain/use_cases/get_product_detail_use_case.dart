import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../store_detail/domain/models/product_model.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase {
  const GetProductDetailUseCase(this._repository);
  final ProductRepository _repository;

  Future<Either<Failure, ProductModel>> getDetail({required String productId}) =>
      _repository.getProductDetail(productId: productId);
}
