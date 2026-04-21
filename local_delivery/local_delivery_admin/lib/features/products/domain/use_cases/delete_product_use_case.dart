import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  const DeleteProductUseCase(this._repository);
  final ProductRepository _repository;

  Future<Either<Failure, void>> deleteProduct({required String id}) =>
      _repository.deleteProduct(id: id);
}
