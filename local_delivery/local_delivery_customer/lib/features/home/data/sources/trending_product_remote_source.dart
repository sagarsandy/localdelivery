import '../dto/trending_product_dto.dart';

abstract class TrendingProductRemoteSource {
  Future<List<TrendingProductDto>> fetchTrendingProducts({int limit = 10});
}
