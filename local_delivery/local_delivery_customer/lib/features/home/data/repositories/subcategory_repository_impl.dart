import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/subcategory_model.dart';
import '../../domain/repositories/subcategory_repository.dart';
import '../sources/subcategory_remote_source.dart';

class SubcategoryRepositoryImpl implements SubcategoryRepository {
  const SubcategoryRepositoryImpl(this._source);
  final SubcategoryRemoteSource _source;

  @override
  Future<Either<Failure, List<SubcategoryModel>>> getSubcategories({required String categoryId}) async {
    try {
      final dtos = await _source.fetchSubcategories(categoryId: categoryId);
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
