import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  const DeleteCategoryUseCase(this._repository);
  final CategoryRepository _repository;

  Future<Either<Failure, void>> deleteCategory({required String id}) =>
      _repository.deleteCategory(id: id);
}
