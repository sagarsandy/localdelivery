import '../dto/subcategory_dto.dart';

abstract class SubcategoryRemoteSource {
  Future<List<SubcategoryDto>> fetchSubcategories();
  Future<void> addSubcategory({
    required String title,
    required String image,
    required String category,
  });
  Future<void> updateSubcategory({
    required String id,
    required String title,
    required String image,
    required String category,
  });
  Future<void> deleteSubcategory({required String id});
}
