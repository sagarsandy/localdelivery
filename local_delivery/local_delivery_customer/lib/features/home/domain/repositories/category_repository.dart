import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/category_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}
