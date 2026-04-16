import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../di/service_locator.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../../cart/cubit/cart_state.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../cubit/checkout_cubit.dart';
import '../../cubit/checkout_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'Cash on Delivery';
  String? _selectedAddressId;

  final _paymentMethods = [
    'Cash on Delivery',
    'UPI',
    'Credit/Debit Card',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CheckoutCubit>(),
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            locator<CartCubit>().clearCart();
            LDToast.show(
              context,
              message: 'Order placed successfully!',
              type: LDToastType.success,
            );
            context.go(LDAppRoute.orders.path);
          } else if (state is CheckoutError) {
            LDToast.show(
              context,
              message: state.message,
              type: LDToastType.error,
            );
          }
        },
        builder: (context, checkoutState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final items = cartState is CartLoaded
                    ? cartState.items
                    : <CartItemModel>[];
                final total = items.fold<double>(0, (s, i) => s + i.totalPrice);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary', style: context.titleLarge),
                      const SizedBox(height: 12),
                      ...items.map((item) => _OrderSummaryRow(item: item)),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: context.bodyMedium),
                          Text('₹${total.toStringAsFixed(0)}',
                              style: context.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Fee', style: context.bodyMedium),
                          Text('₹30', style: context.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: context.titleMedium),
                          Text('₹${(total + 30).toStringAsFixed(0)}',
                              style: context.titleMedium
                                  .copyWith(color: LDColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Delivery Address', style: context.titleLarge),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.push(LDAppRoute.addresses.path),
                        icon: const Icon(Icons.location_on_outlined),
                        label: Text(_selectedAddressId == null
                            ? 'Select Address'
                            : 'Address Selected'),
                      ),
                      const SizedBox(height: 24),
                      Text('Payment Method', style: context.titleLarge),
                      const SizedBox(height: 8),
                      ..._paymentMethods.map(
                        (method) => RadioListTile<String>(
                          title: Text(method),
                          value: method,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) =>
                              setState(() => _selectedPaymentMethod = value!),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LDButton(
                        label: 'Place Order',
                        isLoading: checkoutState is CheckoutLoading,
                        onPressed: () {
                          context.read<CheckoutCubit>().placeOrder(
                                addressId: _selectedAddressId ?? '',
                                paymentMethod: _selectedPaymentMethod,
                                cartItems: items,
                              );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  const _OrderSummaryRow({required this.item});
  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text('${item.productName} × ${item.quantity}',
                style: context.bodyMedium),
          ),
          Text('₹${item.totalPrice.toStringAsFixed(0)}',
              style: context.bodyMedium),
        ],
      ),
    );
  }
}
