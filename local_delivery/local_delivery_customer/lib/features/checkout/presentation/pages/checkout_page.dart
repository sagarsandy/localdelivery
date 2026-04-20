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
import '../../../coupon/cubit/coupon_cubit.dart';
import '../../../coupon/cubit/coupon_state.dart';
import '../../cubit/checkout_cubit.dart';
import '../../cubit/checkout_state.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<CheckoutCubit>()),
        BlocProvider(create: (_) => locator<CouponCubit>()),
        BlocProvider.value(value: locator<AddressCubit>()),
      ],
      child: const _CheckoutScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scaffold — listens to CheckoutCubit for success/error side-effects
// ─────────────────────────────────────────────────────────────────────────────
class _CheckoutScaffold extends StatelessWidget {
  const _CheckoutScaffold();

  static const String _paymentMethod = 'Cash on Delivery';

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          locator<CartCubit>().clearCart();
          context.read<CouponCubit>().removeCoupon();
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
      child: Scaffold(
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
        body: _CheckoutBody(paymentMethod: _paymentMethod),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body — StatefulWidget for the coupon text controller
// ─────────────────────────────────────────────────────────────────────────────
class _CheckoutBody extends StatefulWidget {
  const _CheckoutBody({required this.paymentMethod});
  final String paymentMethod;

  @override
  State<_CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<_CheckoutBody> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      bloc: locator<CartCubit>(),
      builder: (context, cartState) {
        final items =
            cartState is CartLoaded ? cartState.items : <CartItemModel>[];
        final subtotal = items.fold<double>(0, (s, i) => s + i.totalPrice);

        return BlocBuilder<CouponCubit, CouponState>(
          builder: (context, couponState) {
            final discountAmount = couponState is CouponApplied
                ? couponState.discountAmount
                : 0.0;
            final appliedCoupon =
                couponState is CouponApplied ? couponState.coupon : null;
            final grandTotal = subtotal -
                discountAmount +
                LDConstants.deliveryCharge +
                LDConstants.platformFee;

            return BlocBuilder<AddressCubit, AddressState>(
              builder: (context, addressState) {
                final activeAddress = addressState is AddressLoaded
                    ? addressState.activeAddress
                    : null;

                return BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, checkoutState) {
                    final isPlacingOrder = checkoutState is CheckoutLoading;

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Order Summary ──────────────────────────
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
                                      ...items.map((item) =>
                                          _OrderItemRow(item: item)),
                                      if (items.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Center(
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

                                // ── Price Details ──────────────────────────
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
                                      _PriceRow(
                                        label: 'Subtotal',
                                        value:
                                            '₹${subtotal.toStringAsFixed(0)}',
                                      ),
                                      if (discountAmount > 0) ...[
                                        const SizedBox(height: 10),
                                        _PriceRow(
                                          label:
                                              'Coupon (${appliedCoupon?.code ?? ''})',
                                          value:
                                              '− ₹${discountAmount.toStringAsFixed(0)}',
                                          valueColor: LDColors.primary,
                                        ),
                                      ],
                                      const SizedBox(height: 10),
                                      _PriceRow(
                                        label: 'Delivery charge',
                                        value:
                                            '₹${LDConstants.deliveryCharge.toStringAsFixed(0)}',
                                        valueColor: Colors.black54,
                                      ),
                                      const SizedBox(height: 10),
                                      _PriceRow(
                                        label: 'Platform fee',
                                        value:
                                            '₹${LDConstants.platformFee.toStringAsFixed(0)}',
                                        valueColor: Colors.black54,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Divider(
                                          height: 1,
                                          color: Color(0xFFEEEEEE),
                                        ),
                                      ),
                                      _PriceRow(
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

                                // ── Delivery Address ───────────────────────
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
                                          activeAddress: activeAddress),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Coupon / Promo ─────────────────────────
                                _SectionCard(
                                  child: _CouponSectionWidget(
                                    controller: _couponController,
                                    couponState: couponState,
                                    subtotal: subtotal,
                                    onRemove: () {
                                      _couponController.clear();
                                      context
                                          .read<CouponCubit>()
                                          .removeCoupon();
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Payment Method ─────────────────────────
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
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: const BoxDecoration(
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

                        // ── Place Order button ─────────────────────────────
                        _PlaceOrderButton(
                          grandTotal: grandTotal,
                          isLoading: isPlacingOrder,
                          onPressed: items.isEmpty
                              ? null
                              : () {
                                  context.read<CheckoutCubit>().placeOrder(
                                        addressId: activeAddress?.id ?? '',
                                        paymentMethod: widget.paymentMethod,
                                        cartItems: items,
                                        subtotal: subtotal,
                                        discountAmount: discountAmount,
                                        couponCode: appliedCoupon?.code,
                                      );
                                },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Coupon section widget
// ─────────────────────────────────────────────────────────────────────────────
class _CouponSectionWidget extends StatelessWidget {
  const _CouponSectionWidget({
    required this.controller,
    required this.couponState,
    required this.subtotal,
    required this.onRemove,
  });

  final TextEditingController controller;
  final CouponState couponState;
  final double subtotal;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          icon: Icons.local_offer_outlined,
          label: 'Coupon / Promo',
        ),
        const SizedBox(height: 14),

        // ── Applied state ──────────────────────────────────────────────────
        if (couponState is CouponApplied) ...[
          _AppliedCouponBanner(
            state: couponState as CouponApplied,
            onRemove: onRemove,
          ),
        ] else ...[
          // ── Input row ──────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: couponState is CouponError
                          ? Colors.red.shade400
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade400,
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                    ),
                    onSubmitted: (_) => _applyPressed(context),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: couponState is CouponValidating
                    ? null
                    : () => _applyPressed(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: couponState is CouponValidating
                        ? Colors.grey.shade300
                        : LDColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: couponState is CouponValidating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),

          // ── Error message ──────────────────────────────────────────────
          if (couponState is CouponError) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.error_outline,
                    color: Colors.red.shade500, size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (couponState as CouponError).message,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  void _applyPressed(BuildContext context) {
    context.read<CouponCubit>().applyCoupon(
          code: controller.text,
          subtotal: subtotal,
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Applied coupon banner
// ─────────────────────────────────────────────────────────────────────────────
class _AppliedCouponBanner extends StatelessWidget {
  const _AppliedCouponBanner({required this.state, required this.onRemove});
  final CouponApplied state;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isPercent = state.coupon.isPercentage;
    final label = isPercent
        ? '${state.coupon.value}% off applied'
        : '₹${state.coupon.value} off applied';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LDColors.primary),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: LDColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.coupon.code,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LDColors.primary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$label · you save ₹${state.discountAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close_rounded,
                  size: 16, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Delivery address
// ─────────────────────────────────────────────────────────────────────────────
class _DeliveryAddressWidget extends StatelessWidget {
  const _DeliveryAddressWidget({this.activeAddress});
  final AddressModel? activeAddress;

  @override
  Widget build(BuildContext context) {
    if (activeAddress != null) {
      return _AddressDetailsCard(address: activeAddress!);
    }
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
        border: Border.all(color: LDColors.primary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
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
                  address.city,
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
            child: const Text(
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
// Shared UI atoms
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

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});
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

class _PriceRow extends StatelessWidget {
  const _PriceRow({
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

class _PlaceOrderButton extends StatelessWidget {
  const _PlaceOrderButton({
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
            color: onPressed == null ? Colors.grey.shade300 : LDColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
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
