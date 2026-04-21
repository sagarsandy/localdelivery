import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  const UpdateCategoryUseCase(this._repository);
  final CategoryRepository _repository;

  Future<Either<Failure, void>> updateCategory({
    required String id,
    required String title,
    required String image,
  }) =>
      _repository.updateCategory(id: id, title: title, image: image);
}
