import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/order_detail_model.dart';
import '../../domain/repositories/order_detail_repository.dart';
import '../sources/order_detail_remote_source.dart';

class OrderDetailRepositoryImpl implements OrderDetailRepository {
  const OrderDetailRepositoryImpl(this._source);
  final OrderDetailRemoteSource _source;

  @override
  Future<Either<Failure, OrderDetailModel>> getOrderDetail({
    required String orderId,
  }) async {
    try {
      final dto = await _source.fetchOrderDetail(orderId: orderId);
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
