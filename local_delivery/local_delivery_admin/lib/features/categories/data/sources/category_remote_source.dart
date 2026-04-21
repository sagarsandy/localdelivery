import '../dto/category_dto.dart';

abstract class CategoryRemoteSource {
  Future<List<CategoryDto>> fetchCategories();
  Future<void> addCategory({required String title, required String image});
  Future<void> updateCategory({
    required String id,
    required String title,
    required String image,
  });
  Future<void> deleteCategory({required String id});
}
