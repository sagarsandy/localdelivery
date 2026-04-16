import 'package:equatable/equatable.dart';
import '../domain/models/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.orders);
  final List<OrderModel> orders;

  @override
  List<Object?> get props => [orders];
}

class OrdersError extends OrdersState {
  const OrdersError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
