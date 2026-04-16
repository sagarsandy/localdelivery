import '../dto/order_dto.dart';

abstract class OrdersRemoteSource {
  Future<List<OrderDto>> fetchOrders({required String userId});
}
