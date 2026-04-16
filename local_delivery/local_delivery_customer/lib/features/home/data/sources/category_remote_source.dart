import '../dto/category_dto.dart';

abstract class CategoryRemoteSource {
  Future<List<CategoryDto>> fetchCategories();
}
