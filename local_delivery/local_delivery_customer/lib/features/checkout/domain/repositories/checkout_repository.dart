import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../../cart/domain/models/cart_item_model.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, String>> placeOrder({
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
