import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../store_detail/domain/models/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductModel>> getProductDetail({
    required String productId,
  });
}
