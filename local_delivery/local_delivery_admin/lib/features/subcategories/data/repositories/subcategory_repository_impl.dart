import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/subcategory_model.dart';
import '../../domain/repositories/subcategory_repository.dart';
import '../sources/subcategory_remote_source.dart';

class SubcategoryRepositoryImpl implements SubcategoryRepository {
  const SubcategoryRepositoryImpl(this._source);
  final SubcategoryRemoteSource _source;

  @override
  Future<Either<Failure, List<SubcategoryModel>>> getSubcategories() async {
    try {
      final dtos = await _source.fetchSubcategories();
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addSubcategory({
    required String title,
    required String image,
    required String category,
  }) async {
    try {
      await _source.addSubcategory(title: title, image: image, category: category);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSubcategory({
    required String id,
    required String title,
    required String image,
    required String category,
  }) async {
    try {
      await _source.updateSubcategory(
          id: id, title: title, image: image, category: category);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubcategory({required String id}) async {
    try {
      await _source.deleteSubcategory(id: id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
