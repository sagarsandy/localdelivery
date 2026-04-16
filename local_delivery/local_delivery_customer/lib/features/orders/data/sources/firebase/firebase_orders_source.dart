import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/order_dto.dart';
import '../orders_remote_source.dart';

class FirebaseOrdersSource implements OrdersRemoteSource {
  FirebaseOrdersSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<List<OrderDto>> fetchOrders({required String userId}) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.orders)
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs.map(OrderDto.fromFirestore).toList();
  }
}
