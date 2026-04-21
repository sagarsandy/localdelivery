import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/category_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, void>> addCategory({
    required String title,
    required String image,
  });
  Future<Either<Failure, void>> updateCategory({
    required String id,
    required String title,
    required String image,
  });
  Future<Either<Failure, void>> deleteCategory({required String id});
}
