import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/subcategory_repository.dart';

class UpdateSubcategoryUseCase {
  const UpdateSubcategoryUseCase(this._repository);
  final SubcategoryRepository _repository;

  Future<Either<Failure, void>> updateSubcategory({
    required String id,
    required String title,
    required String image,
    required String category,
  }) =>
      _repository.updateSubcategory(
          id: id, title: title, image: image, category: category);
}
