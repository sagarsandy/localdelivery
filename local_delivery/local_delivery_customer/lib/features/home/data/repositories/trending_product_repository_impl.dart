import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/trending_product_model.dart';
import '../../domain/repositories/trending_product_repository.dart';
import '../sources/trending_product_remote_source.dart';

class TrendingProductRepositoryImpl implements TrendingProductRepository {
  const TrendingProductRepositoryImpl(this._source);
  final TrendingProductRemoteSource _source;

  @override
  Future<Either<Failure, List<TrendingProductModel>>> getTrendingProducts() async {
    try {
      final dtos = await _source.fetchTrendingProducts();
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
