import 'package:equatable/equatable.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess(this.orderId);
  final String orderId;
  @override
  List<Object?> get props => [orderId];
}

class CheckoutError extends CheckoutState {
  const CheckoutError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
