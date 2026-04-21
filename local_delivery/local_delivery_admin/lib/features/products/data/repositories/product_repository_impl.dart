import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../sources/product_remote_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._source);
  final ProductRemoteSource _source;

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final dtos = await _source.fetchProducts();
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductModel product) async {
    try {
      await _source.addProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductModel product) async {
    try {
      await _source.updateProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct({required String id}) async {
    try {
      await _source.deleteProduct(id: id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
