import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts({
    required String subcategoryId,
  });
}
