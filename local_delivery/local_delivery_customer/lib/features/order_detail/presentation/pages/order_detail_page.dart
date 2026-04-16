import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../domain/models/order_detail_model.dart';
import '../../cubit/order_detail_cubit.dart';
import '../../cubit/order_detail_state.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<OrderDetailCubit>()..loadOrderDetail(orderId),
      child: const _OrderDetailView(),
    );
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
      body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading) return const LDLoadingWidget();
          if (state is OrderDetailError) {
            return LDErrorWidget(
              message: state.message,
              onRetry: () {},
            );
          }
          if (state is OrderDetailLoaded) {
            return _OrderDetailContent(order: state.order);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OrderDetailContent extends StatelessWidget {
  const _OrderDetailContent({required this.order});
  final OrderDetailModel order;

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${order.id.substring(0, 8).toUpperCase()}',
                  style: context.titleMedium),
              LDStatusChip(status: _mapStatus(order.status)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt),
            style:
                context.bodySmall.copyWith(color: LDColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Status Timeline
          _StatusTimeline(status: order.status),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          // Items
          Text('Items Ordered', style: context.titleLarge),
          const SizedBox(height: 8),
          ...order.items.map((item) => _OrderItemRow(item: item)),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // Price breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: context.bodyMedium),
              Text(
                '₹${order.totalAmount.toStringAsFixed(0)}',
                style: context.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Fee', style: context.bodyMedium),
              Text('₹${order.deliveryFee.toStringAsFixed(0)}',
                  style: context.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: context.titleMedium),
              Text(
                '₹${(order.totalAmount + order.deliveryFee).toStringAsFixed(0)}',
                style: context.titleMedium.copyWith(color: LDColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          // Address
          Text('Delivery Address', style: context.titleLarge),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 18, color: LDColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.address.isNotEmpty
                      ? order.address
                      : 'Address not available',
                  style: context.bodyMedium
                      .copyWith(color: LDColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Payment Method', style: context.titleLarge),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.payment_outlined,
                  size: 18, color: LDColors.textSecondary),
              const SizedBox(width: 6),
              Text(order.paymentMethod, style: context.bodyMedium),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});
  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text('${item.name} × ${item.quantity}',
                style: context.bodyMedium),
          ),
          Text('₹${item.totalPrice.toStringAsFixed(0)}',
              style: context.bodyMedium),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Order Placed', 'pending'),
      ('Confirmed', 'confirmed'),
      ('Out for Delivery', 'out_for_delivery'),
      ('Delivered', 'delivered'),
    ];

    final currentIndex = steps.indexWhere((s) => s.$2 == status);

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = currentIndex >= index;
        final isLast = index == steps.length - 1;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? LDColors.primary : LDColors.surfaceVariant,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.$1,
                    style: context.labelSmall.copyWith(
                      color: isCompleted
                          ? LDColors.primary
                          : LDColors.textDisabled,
                      fontWeight: isCompleted
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: currentIndex > index
                        ? LDColors.primary
                        : LDColors.surfaceVariant,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
