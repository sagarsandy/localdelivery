import '../dto/subcategory_dto.dart';

abstract class SubcategoryRemoteSource {
  Future<List<SubcategoryDto>> fetchSubcategories({required String categoryId});
}
