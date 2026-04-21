import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/subcategory_repository.dart';

class AddSubcategoryUseCase {
  const AddSubcategoryUseCase(this._repository);
  final SubcategoryRepository _repository;

  Future<Either<Failure, void>> addSubcategory({
    required String title,
    required String image,
    required String category,
  }) =>
      _repository.addSubcategory(title: title, image: image, category: category);
}
