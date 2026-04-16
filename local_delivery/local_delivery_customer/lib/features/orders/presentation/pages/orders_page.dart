import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../domain/models/order_model.dart';
import '../../cubit/orders_cubit.dart';
import '../../cubit/orders_state.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<OrdersCubit>()..loadOrders(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) return const LDLoadingWidget();
          if (state is OrdersError) {
            return LDErrorWidget(
              message: state.message,
              onRetry: () => context.read<OrdersCubit>().loadOrders(),
            );
          }
          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const LDEmptyStateWidget(
                title: 'No orders yet',
                subtitle: 'Your order history will appear here.',
                icon: Icons.receipt_long_outlined,
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _OrderCard(order: state.orders[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final OrderModel order;

  LDOrderStatus _mapStatus(String status) {
    switch (status) {
      case 'confirmed':
        return LDOrderStatus.confirmed;
      case 'out_for_delivery':
        return LDOrderStatus.outForDelivery;
      case 'delivered':
        return LDOrderStatus.delivered;
      case 'cancelled':
        return LDOrderStatus.cancelled;
      default:
        return LDOrderStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/order/${order.id}', extra: {'order': order}),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(order.storeName, style: context.titleSmall),
                  ),
                  LDStatusChip(status: _mapStatus(order.status)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${order.itemCount} item${order.itemCount == 1 ? '' : 's'} · ₹${order.totalAmount.toStringAsFixed(0)}',
                style: context.bodySmall
                    .copyWith(color: LDColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt),
                style: context.bodySmall
                    .copyWith(color: LDColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'View Details',
                  style: context.bodySmall
                      .copyWith(color: LDColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
