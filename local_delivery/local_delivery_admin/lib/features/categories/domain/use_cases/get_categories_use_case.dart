import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);
  final CategoryRepository _repository;

  Future<Either<Failure, List<CategoryModel>>> getCategories() =>
      _repository.getCategories();
}
