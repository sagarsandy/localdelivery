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
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory({
    required String title,
    required String image,
  }) async {
    try {
      await _source.addCategory(title: title, image: image);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory({
    required String id,
    required String title,
    required String image,
  }) async {
    try {
      await _source.updateCategory(id: id, title: title, image: image);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory({required String id}) async {
    try {
      await _source.deleteCategory(id: id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
