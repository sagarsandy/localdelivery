import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class AddProductUseCase {
  const AddProductUseCase(this._repository);
  final ProductRepository _repository;

  Future<Either<Failure, void>> addProduct(ProductModel product) =>
      _repository.addProduct(product);
}
