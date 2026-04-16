import '../dto/order_detail_dto.dart';

abstract class OrderDetailRemoteSource {
  Future<OrderDetailDto> fetchOrderDetail({required String orderId});
}
