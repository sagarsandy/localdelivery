import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/models/cart_item_model.dart';
import '../domain/use_cases/get_cart_use_case.dart';
import '../domain/use_cases/update_cart_use_case.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._getCartUseCase, this._updateCartUseCase) : super(CartInitial());

  final GetCartUseCase _getCartUseCase;
  final UpdateCartUseCase _updateCartUseCase;

  Future<void> loadCart() async {
    emit(CartLoading());
    final result = await _getCartUseCase.getCart();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> addItem(CartItemModel item) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final existingIndex = currentState.items
        .indexWhere((e) => e.productId == item.productId);
    List<CartItemModel> updatedItems;
    if (existingIndex >= 0) {
      updatedItems = List.from(currentState.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + item.quantity,
      );
    } else {
      updatedItems = [...currentState.items, item];
    }
    await _persist(updatedItems);
  }

  Future<void> removeItem(String productId) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;
    final updatedItems =
        currentState.items.where((e) => e.productId != productId).toList();
    await _persist(updatedItems);
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }
    final updatedItems = currentState.items.map((e) {
      if (e.productId == productId) return e.copyWith(quantity: quantity);
      return e;
    }).toList();
    await _persist(updatedItems);
  }

  Future<void> clearCart() async {
    final result = await _updateCartUseCase.updateCart([]);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartLoaded([])),
    );
  }

  Future<void> _persist(List<CartItemModel> items) async {
    final result = await _updateCartUseCase.updateCart(items);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(CartLoaded(items)),
    );
  }
}
