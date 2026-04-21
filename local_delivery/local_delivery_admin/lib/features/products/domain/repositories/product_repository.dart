import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, void>> addProduct(ProductModel product);
  Future<Either<Failure, void>> updateProduct(ProductModel product);
  Future<Either<Failure, void>> deleteProduct({required String id});
}
