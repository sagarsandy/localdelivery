import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/trending_product_model.dart';
import '../repositories/trending_product_repository.dart';

class GetTrendingProductsUseCase {
  const GetTrendingProductsUseCase(this._repository);
  final TrendingProductRepository _repository;

  Future<Either<Failure, List<TrendingProductModel>>> getTrendingProducts() =>
      _repository.getTrendingProducts();
}
