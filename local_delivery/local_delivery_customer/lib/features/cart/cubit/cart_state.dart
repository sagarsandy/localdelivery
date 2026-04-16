import 'package:equatable/equatable.dart';
import '../domain/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  const CartLoaded(this.items);
  final List<CartItemModel> items;

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  CartLoaded copyWith({List<CartItemModel>? items}) =>
      CartLoaded(items ?? this.items);

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  const CartError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
