import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/category_model.dart';
import '../../domain/repositories/category_repository.dart';
import '../sources/category_remote_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._source);
  final CategoryRemoteSource _source;

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final dtos = await _source.fetchCategories();
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
