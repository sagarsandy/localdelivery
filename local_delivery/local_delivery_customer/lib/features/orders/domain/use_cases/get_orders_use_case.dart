import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/order_model.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUseCase {
  const GetOrdersUseCase(this._repository);
  final OrdersRepository _repository;

  Future<Either<Failure, List<OrderModel>>> getOrders({required String userId}) =>
      _repository.getOrders(userId: userId);
}
