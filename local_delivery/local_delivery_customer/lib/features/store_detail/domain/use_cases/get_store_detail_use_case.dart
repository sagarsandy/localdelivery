import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../home/domain/models/store_model.dart';
import '../repositories/store_detail_repository.dart';

class GetStoreDetailUseCase {
  const GetStoreDetailUseCase(this._repository);
  final StoreDetailRepository _repository;

  Future<Either<Failure, StoreModel>> getDetail({required String storeId}) =>
      _repository.getStoreDetail(storeId: storeId);
}
