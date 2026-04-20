import '../../../cart/domain/models/cart_item_model.dart';

abstract class CheckoutRemoteSource {
  /// Places the order atomically and records coupon usage if provided.
  /// Returns the new order's document ID.
  Future<String> placeOrder({
    required String userId,
    required String phone,
    required String addressId,
    required String paymentMethod,
    required List<CartItemModel> cartItems,
    required double totalAmount,
    required double discountAmount,
    String? couponCode,
  });
}
