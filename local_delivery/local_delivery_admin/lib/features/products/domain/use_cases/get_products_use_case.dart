import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);
  final ProductRepository _repository;

  Future<Either<Failure, List<ProductModel>>> getProducts() =>
      _repository.getProducts();
}
