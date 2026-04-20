import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/ld_constants.dart';
import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../../../cart/domain/models/cart_item_model.dart';
import '../checkout_remote_source.dart';

class FirebaseCheckoutSource implements CheckoutRemoteSource {
  FirebaseCheckoutSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<String> placeOrder({
    required String userId,
    required String addressId,
    required String paymentMethod,
    required List<CartItemModel> cartItems,
  }) async {
    final totalAmount =
        cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);

    final batch = _firestore.batch();
    final orderRef = _firestore.collection(FirebaseCollections.orders).doc();

    batch.set(orderRef, {
      'user_id': userId,
      'status': 'pending',
      'total_amount': totalAmount,
      'delivery_fee': LDConstants.deliveryCharge,
      'address_id': addressId,
      'payment_method': paymentMethod,
      'item_count': cartItems.length,
      'created_at': FieldValue.serverTimestamp(),
    });

    for (final item in cartItems) {
      final itemRef =
          _firestore.collection(FirebaseCollections.orderItems).doc();
      batch.set(itemRef, {
        'order_id': orderRef.id,
        'product_id': item.productId,
        'name': item.productName,
        'price': item.price,
        'quantity': item.quantity,
      });
    }

    await batch.commit();
    return orderRef.id;
  }
}
