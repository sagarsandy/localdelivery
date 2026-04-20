import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../di/service_locator.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../../cart/cubit/cart_state.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../domain/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<CartCubit>(),
      child: _ProductDetailView(product: product),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main view
// ─────────────────────────────────────────────────────────────────────────────
class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Sticky smart cart button
      bottomNavigationBar: _SmartCartButtonWidget(product: product),
      body: Stack(
        children: [
          // ── Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero image — 1/3 screen height
                _ProductImageWidget(product: product),

                // ── All the detail content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Qty + units
                      Text(
                        '${product.quantity} ${product.units}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price row
                      _PriceRowWidget(product: product),
                      const SizedBox(height: 16),

                      // Delivery chip
                      const _DeliveryChipWidget(),
                      const SizedBox(height: 24),

                      // Divider
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 20),

                      // Description
                      _DescriptionWidget(product: product),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Floating back button over image
          const _FloatingBackButtonWidget(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero image — fills 1/3 of screen height
// ─────────────────────────────────────────────────────────────────────────────
class _ProductImageWidget extends StatelessWidget {
  const _ProductImageWidget({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.sizeOf(context).height / 3;
    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LDNetworkImage(
            url: product.imageUrl,
            width: double.infinity,
            height: imageHeight,
            fit: BoxFit.cover,
          ),
          // Subtle bottom gradient for readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Out of stock badge
          if (!product.isAvailable || !product.inStock)
            Positioned(
              top: 60,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Out of Stock',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating back button — overlaid on top-left of the image
// ─────────────────────────────────────────────────────────────────────────────
class _FloatingBackButtonWidget extends StatelessWidget {
  const _FloatingBackButtonWidget();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Price row — sale price + strikethrough + % OFF badge
// ─────────────────────────────────────────────────────────────────────────────
class _PriceRowWidget extends StatelessWidget {
  const _PriceRowWidget({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: [
        // Current / sale price
        Text(
          product.formattedPrice,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: LDColors.primary,
            height: 1,
          ),
        ),

        if (product.hasDiscount) ...[
          // Original (MRP) struck-through
          Text(
            product.formattedOriginalPrice,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.black38,
              height: 1,
            ),
          ),

          // % OFF badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: LDColors.primary, width: 0.5),
            ),
            child: Text(
              '${product.discountPercent}% OFF',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: LDColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Delivery chip — highlighted 15-min delivery
// ─────────────────────────────────────────────────────────────────────────────
class _DeliveryChipWidget extends StatelessWidget {
  const _DeliveryChipWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LDColors.primary, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: LDColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.electric_bolt_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '15 minutes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: LDColors.primary,
                ),
              ),
              Text(
                'Express delivery',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: LDColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Description section
// ─────────────────────────────────────────────────────────────────────────────
class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final desc = product.description;
    if (desc == null || desc.trim().isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this product',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          desc,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Smart Add-to-Cart bottom bar
//
// State A — not in cart:   [    Add to Cart    ]
// State B — in cart:       [ 🛒 N ]  [ − qty + ]
// ─────────────────────────────────────────────────────────────────────────────
class _SmartCartButtonWidget extends StatefulWidget {
  const _SmartCartButtonWidget({required this.product});
  final ProductModel product;

  @override
  State<_SmartCartButtonWidget> createState() => _SmartCartButtonWidgetState();
}

class _SmartCartButtonWidgetState extends State<_SmartCartButtonWidget> {
  @override
  void initState() {
    super.initState();
    // Ensure cart is loaded so we can reflect current qty.
    final cubit = locator<CartCubit>();
    if (cubit.state is CartInitial) cubit.loadCart();
  }

  void _add() {
    locator<CartCubit>().addItem(CartItemModel(
      productId: widget.product.id,
      productName: widget.product.name,
      productImage: widget.product.imageUrl,
      price: widget.product.price,
      quantity: 1,
    ));
  }

  void _increment(int currentQty) {
    locator<CartCubit>().updateQuantity(widget.product.id, currentQty + 1);
  }

  void _decrement(int currentQty) {
    if (currentQty <= 1) {
      locator<CartCubit>().removeItem(widget.product.id);
    } else {
      locator<CartCubit>().updateQuantity(widget.product.id, currentQty - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnavailable =
        !widget.product.isAvailable || !widget.product.inStock;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        int inCartQty = 0;
        int totalCartItems = 0;

        if (state is CartLoaded) {
          final match = state.items
              .where((i) => i.productId == widget.product.id)
              .firstOrNull;
          inCartQty = match?.quantity ?? 0;
          totalCartItems = state.itemCount;
        }

        return Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
          // decoration: BoxDecoration(
          //   color: Colors.clear,
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.08),
          //       blurRadius: 16,
          //       offset: const Offset(0, -4),
          //     ),
          //   ],
          // ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: inCartQty == 0
                ? _AddToCartButton(
                    key: const ValueKey('add'),
                    isUnavailable: isUnavailable,
                    onTap: isUnavailable ? null : _add,
                  )
                : _CartControlsRow(
                    key: const ValueKey('controls'),
                    qty: inCartQty,
                    totalItems: totalCartItems,
                    onDecrement: () => _decrement(inCartQty),
                    onIncrement: () => _increment(inCartQty),
                    onCartTap: () => context.go(LDAppRoute.cart.path),
                  ),
          ),
        );
      },
    );
  }
}

// ── State A: "Add to Cart" button
class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    super.key,
    required this.isUnavailable,
    required this.onTap,
  });

  final bool isUnavailable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isUnavailable ? Colors.grey.shade300 : LDColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: isUnavailable ? Colors.grey.shade500 : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              isUnavailable ? 'Out of Stock' : 'Add to Cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isUnavailable ? Colors.grey.shade500 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── State B: Cart pill + quantity stepper
class _CartControlsRow extends StatelessWidget {
  const _CartControlsRow({
    super.key,
    required this.qty,
    required this.totalItems,
    required this.onDecrement,
    required this.onIncrement,
    required this.onCartTap,
  });

  final int qty;
  final int totalItems;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Left: go-to-cart pill
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: onCartTap,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: LDColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '$totalItems ${totalItems == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // ── Right: stepper [ − qty + ]
        Expanded(
          flex: 4,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: LDColors.primary, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Minus
                _StepperButton(
                  icon: Icons.remove_rounded,
                  onTap: onDecrement,
                ),

                // Current qty for this product
                Text(
                  '$qty',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: LDColors.primary,
                  ),
                ),

                // Plus
                _StepperButton(
                  icon: Icons.add_rounded,
                  onTap: onIncrement,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Icon(icon, color: LDColors.primary, size: 22),
      ),
    );
  }
}
