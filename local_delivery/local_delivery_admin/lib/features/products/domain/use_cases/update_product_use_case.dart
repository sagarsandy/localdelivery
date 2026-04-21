import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  const UpdateProductUseCase(this._repository);
  final ProductRepository _repository;

  Future<Either<Failure, void>> updateProduct(ProductModel product) =>
      _repository.updateProduct(product);
}
