import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/order_model.dart';
import '../../domain/repositories/orders_repository.dart';
import '../sources/orders_remote_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this._source);
  final OrdersRemoteSource _source;

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders({
    required String userId,
  }) async {
    try {
      final dtos = await _source.fetchOrders(userId: userId);
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
