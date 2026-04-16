import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../../../orders/data/dto/order_dto.dart';
import '../../dto/order_detail_dto.dart';
import '../order_detail_remote_source.dart';

class FirebaseOrderDetailSource implements OrderDetailRemoteSource {
  FirebaseOrderDetailSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<OrderDetailDto> fetchOrderDetail({required String orderId}) async {
    final orderDoc = await _firestore
        .collection(FirebaseCollections.orders)
        .doc(orderId)
        .get();
    if (!orderDoc.exists || orderDoc.data() == null) {
      throw Exception('Order not found: $orderId');
    }
    final orderDto = OrderDto.fromFirestoreDoc(orderDoc);

    final itemsSnapshot = await _firestore
        .collection(FirebaseCollections.orderItems)
        .where('order_id', isEqualTo: orderId)
        .get();
    final items = itemsSnapshot.docs.map(OrderItemDto.fromFirestore).toList();

    // Fetch address text — non-critical, silently skip on failure.
    String address = '';
    final addressId = orderDoc.data()!['address_id'] as String?;
    if (addressId != null) {
      try {
        final addressDoc = await _firestore
            .collection(FirebaseCollections.addresses)
            .doc(addressId)
            .get();
        if (addressDoc.exists && addressDoc.data() != null) {
          final a = addressDoc.data()!;
          address = '${a['address_line_1']}, ${a['city']} - ${a['pincode']}';
        }
      } catch (_) {}
    }

    final paymentMethod =
        orderDoc.data()!['payment_method'] as String? ?? 'Cash on Delivery';

    return OrderDetailDto(
      order: orderDto,
      items: items,
      address: address,
      paymentMethod: paymentMethod,
    );
  }
}
