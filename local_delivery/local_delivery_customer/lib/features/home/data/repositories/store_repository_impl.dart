import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/store_model.dart';
import '../../domain/repositories/store_repository.dart';
import '../sources/store_remote_source.dart';

class StoreRepositoryImpl implements StoreRepository {
  const StoreRepositoryImpl(this._source);
  final StoreRemoteSource _source;

  @override
  Future<Either<Failure, List<StoreModel>>> getStores({
    String? categoryId,
  }) async {
    try {
      final dtos = await _source.fetchStores(categoryId: categoryId);
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
