import '../../domain/models/product_model.dart';
import '../dto/product_dto.dart';

abstract class ProductRemoteSource {
  Future<List<ProductDto>> fetchProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct({required String id});
}
