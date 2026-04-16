import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../sources/checkout_remote_source.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this._source);
  final CheckoutRemoteSource _source;

  @override
  Future<Either<Failure, String>> placeOrder({
    required String userId,
    required String addressId,
    required String paymentMethod,
    required List<CartItemModel> cartItems,
  }) async {
    try {
      final orderId = await _source.placeOrder(
        userId: userId,
        addressId: addressId,
        paymentMethod: paymentMethod,
        cartItems: cartItems,
      );
      return Right(orderId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
