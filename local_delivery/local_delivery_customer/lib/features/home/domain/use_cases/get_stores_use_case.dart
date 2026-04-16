import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/store_model.dart';
import '../repositories/store_repository.dart';

class GetStoresUseCase {
  const GetStoresUseCase(this._repository);
  final StoreRepository _repository;

  Future<Either<Failure, List<StoreModel>>> getStores({String? categoryId}) =>
      _repository.getStores(categoryId: categoryId);
}
