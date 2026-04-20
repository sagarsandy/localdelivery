import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../core/constants/ld_constants.dart';
import '../../../../di/service_locator.dart';
import '../../../address/cubit/address_cubit.dart';
import '../../../address/cubit/address_state.dart';
import '../../../address/domain/models/address_model.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../../cart/cubit/cart_state.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../cubit/checkout_cubit.dart';
import '../../cubit/checkout_state.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  static const String _paymentMethod = 'Cash on Delivery';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<CheckoutCubit>()),
        BlocProvider.value(value: locator<AddressCubit>()),
      ],
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
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(height: 1, color: Colors.grey.shade200),
              ),
            ),
            body: BlocBuilder<CartCubit, CartState>(
              bloc: locator<CartCubit>(),
              builder: (context, cartState) {
                final items = cartState is CartLoaded
                    ? cartState.items
                    : <CartItemModel>[];
                final subtotal =
                    items.fold<double>(0, (s, i) => s + i.totalPrice);
                final grandTotal = subtotal +
                    LDConstants.deliveryCharge +
                    LDConstants.platformFee;

                return BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, addressState) {
                    final activeAddress = addressState is AddressLoaded
                        ? addressState.activeAddress
                        : null;

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Order summary card
                                _SectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const _SectionTitle(
                                        icon: Icons.receipt_long_rounded,
                                        label: 'Order Summary',
                                      ),
                                      const SizedBox(height: 12),
                                      ...items.map(
                                        (item) =>
                                            _OrderItemRowWidget(item: item),
                                      ),
                                      if (items.isEmpty)
                                        const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              'Your cart is empty',
                                              style: TextStyle(
                                                  color: Colors.black45),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Price breakdown card
                                _SectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const _SectionTitle(
                                        icon: Icons.calculate_outlined,
                                        label: 'Price Details',
                                      ),
                                      const SizedBox(height: 16),
                                      _PriceRowWidget(
                                        label: 'Subtotal',
                                        value:
                                            '₹${subtotal.toStringAsFixed(0)}',
                                      ),
                                      const SizedBox(height: 10),
                                      _PriceRowWidget(
                                        label: 'Delivery charge',
                                        value:
                                            '₹${LDConstants.deliveryCharge.toStringAsFixed(0)}',
                                        valueColor: Colors.black54,
                                      ),
                                      const SizedBox(height: 10),
                                      _PriceRowWidget(
                                        label: 'Platform fee',
                                        value:
                                            '₹${LDConstants.platformFee.toStringAsFixed(0)}',
                                        valueColor: Colors.black54,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        child: Divider(
                                          height: 1,
                                          color: Color(0xFFEEEEEE),
                                        ),
                                      ),
                                      _PriceRowWidget(
                                        label: 'Total',
                                        value:
                                            '₹${grandTotal.toStringAsFixed(0)}',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                        ),
                                        valueStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          color: LDColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Delivery address card
                                _SectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const _SectionTitle(
                                        icon: Icons.location_on_outlined,
                                        label: 'Delivery Address',
                                      ),
                                      const SizedBox(height: 12),
                                      _DeliveryAddressWidget(
                                        activeAddress: activeAddress,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Payment method card (COD only)
                                _SectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const _SectionTitle(
                                        icon: Icons.payments_outlined,
                                        label: 'Payment Method',
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: LDColors.primary,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: LDColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.money_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Cash on Delivery',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'Pay when your order arrives',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.check_circle_rounded,
                                              color: LDColors.primary,
                                              size: 22,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),

                        // ── Sticky Place Order button
                        _PlaceOrderButtonWidget(
                          grandTotal: grandTotal,
                          isLoading: checkoutState is CheckoutLoading,
                          onPressed: items.isEmpty
                              ? null
                              : () {
                                  context.read<CheckoutCubit>().placeOrder(
                                        addressId: activeAddress?.id ?? '',
                                        paymentMethod: _paymentMethod,
                                        cartItems: items,
                                      );
                                },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Delivery address widget — shows active address or prompts to set one
// ─────────────────────────────────────────────────────────────────────────────
class _DeliveryAddressWidget extends StatelessWidget {
  const _DeliveryAddressWidget({this.activeAddress});
  final AddressModel? activeAddress;

  @override
  Widget build(BuildContext context) {
    if (activeAddress != null) {
      return _AddressDetailsCard(address: activeAddress!);
    }

    // No active address — prompt to go to addresses page.
    return GestureDetector(
      onTap: () => context.push(LDAppRoute.addresses.path),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_location_alt_outlined,
                color: Colors.black45, size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Set a delivery address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _AddressDetailsCard extends StatelessWidget {
  const _AddressDetailsCard({required this.address});
  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LDColors.primary, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: LDColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address.fullAddress,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push(LDAppRoute.addresses.path),
            child: Text(
              'Change',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: LDColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable white card wrapper
// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section title with icon
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: LDColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Order item row — name × qty | price
// ─────────────────────────────────────────────────────────────────────────────
class _OrderItemRowWidget extends StatelessWidget {
  const _OrderItemRowWidget({required this.item});
  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: LDColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.productName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '× ${item.quantity}',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '₹${item.totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Price breakdown row
// ─────────────────────────────────────────────────────────────────────────────
class _PriceRowWidget extends StatelessWidget {
  const _PriceRowWidget({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sticky Place Order button
// ─────────────────────────────────────────────────────────────────────────────
class _PlaceOrderButtonWidget extends StatelessWidget {
  const _PlaceOrderButtonWidget({
    required this.grandTotal,
    required this.isLoading,
    required this.onPressed,
  });

  final double grandTotal;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 54,
          decoration: BoxDecoration(
            color: onPressed == null
                ? Colors.grey.shade300
                : LDColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Place Order · ₹${grandTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
