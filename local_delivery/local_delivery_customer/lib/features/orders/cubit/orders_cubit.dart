import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/session/user_session.dart';
import '../domain/use_cases/get_orders_use_case.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._getOrdersUseCase) : super(OrdersInitial());

  final GetOrdersUseCase _getOrdersUseCase;

  Future<void> loadOrders() async {
    final userId = UserSession.instance.userId;
    if (userId == null) {
      emit(const OrdersError('User not logged in.'));
      return;
    }
    emit(OrdersLoading());
    final result = await _getOrdersUseCase.getOrders(userId: userId);
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }
}
