import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/trending_product_model.dart';

abstract class TrendingProductRepository {
  Future<Either<Failure, List<TrendingProductModel>>> getTrendingProducts();
}
