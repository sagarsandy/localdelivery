import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../home/domain/models/store_model.dart';
import '../models/product_model.dart';

abstract class StoreDetailRepository {
  Future<Either<Failure, StoreModel>> getStoreDetail({required String storeId});
  Future<Either<Failure, List<ProductModel>>> getStoreProducts({
    required String storeId,
    String? categoryId,
  });
}
