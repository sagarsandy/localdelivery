import '../../../cart/domain/models/cart_item_model.dart';

abstract class CheckoutRemoteSource {
  /// Places the order atomically. Returns the new order's document ID.
  Future<String> placeOrder({
    required String userId,
    required String addressId,
    required String paymentMethod,
    required List<CartItemModel> cartItems,
  });
}
