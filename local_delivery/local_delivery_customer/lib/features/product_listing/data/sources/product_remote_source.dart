import '../dto/product_dto.dart';

abstract class ProductRemoteSource {
  Future<List<ProductDto>> fetchProducts({required String subcategoryId});
}
