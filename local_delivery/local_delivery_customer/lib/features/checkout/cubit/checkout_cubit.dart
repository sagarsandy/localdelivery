import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/user_session.dart';
import '../../cart/domain/models/cart_item_model.dart';
import '../domain/repositories/checkout_repository.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._checkoutRepository) : super(CheckoutInitial());

  final CheckoutRepository _checkoutRepository;

  Future<void> placeOrder({
    required String addressId,
    required String paymentMethod,
    required List<CartItemModel> cartItems,
  }) async {
    if (cartItems.isEmpty) {
      emit(const CheckoutError('Your cart is empty.'));
      return;
    }

    final userId = UserSession.instance.userId;
    if (userId == null) {
      emit(const CheckoutError('User not logged in.'));
      return;
    }

    emit(CheckoutLoading());
    final result = await _checkoutRepository.placeOrder(
      userId: userId,
      addressId: addressId,
      paymentMethod: paymentMethod,
      cartItems: cartItems,
    );
    result.fold(
      (failure) => emit(CheckoutError(failure.message)),
      (orderId) => emit(CheckoutSuccess(orderId)),
    );
  }
}
