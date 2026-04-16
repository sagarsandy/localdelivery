import 'package:equatable/equatable.dart';
import '../domain/models/order_detail_model.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();
  @override
  List<Object?> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  const OrderDetailLoaded(this.order);
  final OrderDetailModel order;

  @override
  List<Object?> get props => [order];
}

class OrderDetailError extends OrderDetailState {
  const OrderDetailError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
