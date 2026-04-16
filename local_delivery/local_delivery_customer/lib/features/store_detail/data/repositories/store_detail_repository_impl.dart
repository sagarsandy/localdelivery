import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../../home/domain/models/store_model.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/store_detail_repository.dart';
import '../sources/store_detail_remote_source.dart';

class StoreDetailRepositoryImpl implements StoreDetailRepository {
  const StoreDetailRepositoryImpl(this._source);
  final StoreDetailRemoteSource _source;

  @override
  Future<Either<Failure, StoreModel>> getStoreDetail({
    required String storeId,
  }) async {
    try {
      final dto = await _source.fetchStore(storeId: storeId);
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getStoreProducts({
    required String storeId,
    String? categoryId,
  }) async {
    try {
      final dtos = await _source.fetchProducts(
        storeId: storeId,
        categoryId: categoryId,
      );
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
