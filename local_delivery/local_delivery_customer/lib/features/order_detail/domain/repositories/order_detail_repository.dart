import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/order_detail_model.dart';

abstract class OrderDetailRepository {
  Future<Either<Failure, OrderDetailModel>> getOrderDetail({
    required String orderId,
  });
}
