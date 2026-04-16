import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/order_detail_model.dart';
import '../repositories/order_detail_repository.dart';

class GetOrderDetailUseCase {
  const GetOrderDetailUseCase(this._repository);
  final OrderDetailRepository _repository;

  Future<Either<Failure, OrderDetailModel>> getDetail({required String orderId}) =>
      _repository.getOrderDetail(orderId: orderId);
}
