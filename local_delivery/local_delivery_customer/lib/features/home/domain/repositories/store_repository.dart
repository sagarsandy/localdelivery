import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/store_model.dart';

abstract class StoreRepository {
  Future<Either<Failure, List<StoreModel>>> getStores({String? categoryId});
}
