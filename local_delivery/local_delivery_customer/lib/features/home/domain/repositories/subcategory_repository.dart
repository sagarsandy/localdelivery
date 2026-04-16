import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/subcategory_model.dart';

abstract class SubcategoryRepository {
  Future<Either<Failure, List<SubcategoryModel>>> getSubcategories({required String categoryId});
}
