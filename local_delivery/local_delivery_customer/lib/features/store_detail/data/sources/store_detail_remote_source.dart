import '../../../home/data/dto/store_dto.dart';
import '../dto/product_dto.dart';

abstract class StoreDetailRemoteSource {
  Future<StoreDto> fetchStore({required String storeId});
  Future<List<ProductDto>> fetchProducts({
    required String storeId,
    String? categoryId,
  });
}
