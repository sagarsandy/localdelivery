import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/category_repository.dart';

class AddCategoryUseCase {
  const AddCategoryUseCase(this._repository);
  final CategoryRepository _repository;

  Future<Either<Failure, void>> addCategory({
    required String title,
    required String image,
  }) =>
      _repository.addCategory(title: title, image: image);
}
