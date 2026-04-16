import '../../../store_detail/data/dto/product_dto.dart';

abstract class ProductRemoteSource {
  Future<ProductDto> fetchProduct({required String productId});
}
