import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/use_cases/get_order_detail_use_case.dart';
import 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this._getOrderDetailUseCase) : super(OrderDetailInitial());

  final GetOrderDetailUseCase _getOrderDetailUseCase;

  Future<void> loadOrderDetail(String orderId) async {
    emit(OrderDetailLoading());
    final result = await _getOrderDetailUseCase.getDetail(orderId: orderId);
    result.fold(
      (failure) => emit(OrderDetailError(failure.message)),
      (order) => emit(OrderDetailLoaded(order)),
    );
  }
}
