import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../../store_detail/domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../sources/product_remote_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._source);
  final ProductRemoteSource _source;

  @override
  Future<Either<Failure, ProductModel>> getProductDetail({
    required String productId,
  }) async {
    try {
      final dto = await _source.fetchProduct(productId: productId);
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
