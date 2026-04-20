import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../sources/product_remote_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._source);
  final ProductRemoteSource _source;

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts({
    required String subcategoryId,
  }) async {
    try {
      final dtos = await _source.fetchProducts(subcategoryId: subcategoryId);
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
