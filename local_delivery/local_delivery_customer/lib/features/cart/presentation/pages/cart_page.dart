import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';
import '../../domain/models/cart_item_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CartCubit>()..loadCart(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) return const LDLoadingWidget();
          if (state is CartError) {
            return LDErrorWidget(
              message: state.message,
              onRetry: () => context.read<CartCubit>().loadCart(),
            );
          }
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return const LDEmptyStateWidget(
                title: 'Your cart is empty',
                subtitle: 'Browse products and add items to get started.',
                icon: Icons.shopping_cart_outlined,
              );
            }
            return _CartContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent({required this.state});
  final CartLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _CartItemCard(item: state.items[index]),
          ),
        ),
        const LDDashedDivider(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total (${state.itemCount} items)',
                        style: context.titleMedium),
                    Text(
                      '₹${state.totalPrice.toStringAsFixed(0)}',
                      style:
                          context.titleLarge.copyWith(color: LDColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LDButton(
                  label: 'Proceed to Checkout',
                  onPressed: () => context.push(LDAppRoute.checkout.path),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});
  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LDNetworkImage(
                url: item.productImage,
                width: 64,
                height: 64,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName, style: context.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    '₹${item.price.toStringAsFixed(0)}',
                    style:
                        context.bodySmall.copyWith(color: LDColors.primary),
                  ),
                ],
              ),
            ),
            LDCartQuantityButton(
              quantity: item.quantity,
              onIncrement: () =>
                  cubit.updateQuantity(item.productId, item.quantity + 1),
              onDecrement: () =>
                  cubit.updateQuantity(item.productId, item.quantity - 1),
            ),
          ],
        ),
      ),
    );
  }
}
