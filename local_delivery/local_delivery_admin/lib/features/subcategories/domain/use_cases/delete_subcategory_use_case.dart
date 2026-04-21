import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/subcategory_repository.dart';

class DeleteSubcategoryUseCase {
  const DeleteSubcategoryUseCase(this._repository);
  final SubcategoryRepository _repository;

  Future<Either<Failure, void>> deleteSubcategory({required String id}) =>
      _repository.deleteSubcategory(id: id);
}
