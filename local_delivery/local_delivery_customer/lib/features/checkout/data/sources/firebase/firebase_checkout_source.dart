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
    required String phone,
    required String addressId,
    required String paymentMethod,
    required List<CartItemModel> cartItems,
    required double totalAmount,
    required double discountAmount,
    String? couponCode,
  }) async {
    final batch = _firestore.batch();

    // ── Order document ─────────────────────────────────────────────────────
    final orderRef = _firestore.collection(FirebaseCollections.orders).doc();
    batch.set(orderRef, {
      'userId': userId,
      'phone': phone,
      'status': 'pending',
      'subtotal': totalAmount,
      'discountAmount': discountAmount,
      'couponCode': couponCode,
      'deliveryFee': LDConstants.deliveryCharge,
      'platformFee': LDConstants.platformFee,
      'totalAmount': totalAmount -
          discountAmount +
          LDConstants.deliveryCharge +
          LDConstants.platformFee,
      'addressId': addressId,
      'paymentMethod': paymentMethod,
      'itemCount': cartItems.length,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // ── Order items ────────────────────────────────────────────────────────
    for (final item in cartItems) {
      final itemRef =
          _firestore.collection(FirebaseCollections.orderItems).doc();
      batch.set(itemRef, {
        'orderId': orderRef.id,
        'productId': item.productId,
        'name': item.productName,
        'price': item.price,
        'quantity': item.quantity,
      });
    }

    // ── Mark coupon as used (if one was applied) ───────────────────────────
    if (couponCode != null && couponCode.isNotEmpty && phone.isNotEmpty) {
      final usedRef =
          _firestore.collection(FirebaseCollections.usedCoupons).doc();
      batch.set(usedRef, {
        'coupon': couponCode,
        'phone': phone,
        'date': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    return orderRef.id;
  }
}
