import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/order_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders({required String userId});
}
