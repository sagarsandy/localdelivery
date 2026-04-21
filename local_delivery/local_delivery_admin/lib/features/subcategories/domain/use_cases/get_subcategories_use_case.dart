import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/subcategory_model.dart';
import '../repositories/subcategory_repository.dart';

class GetSubcategoriesUseCase {
  const GetSubcategoriesUseCase(this._repository);
  final SubcategoryRepository _repository;

  Future<Either<Failure, List<SubcategoryModel>>> getSubcategories() =>
      _repository.getSubcategories();
}
