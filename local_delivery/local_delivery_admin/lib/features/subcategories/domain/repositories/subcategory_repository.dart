import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/subcategory_model.dart';

abstract class SubcategoryRepository {
  Future<Either<Failure, List<SubcategoryModel>>> getSubcategories();
  Future<Either<Failure, void>> addSubcategory({
    required String title,
    required String image,
    required String category,
  });
  Future<Either<Failure, void>> updateSubcategory({
    required String id,
    required String title,
    required String image,
    required String category,
  });
  Future<Either<Failure, void>> deleteSubcategory({required String id});
}
