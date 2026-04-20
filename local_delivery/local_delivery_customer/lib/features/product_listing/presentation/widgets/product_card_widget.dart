import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../features/cart/cubit/cart_cubit.dart';
import '../../../../features/cart/domain/models/cart_item_model.dart';
import '../../domain/models/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
  });
  final ProductModel product;

  /// Called when user taps anywhere on the card except the add button.
  final VoidCallback? onTap;

  void _addToCart(BuildContext context) {
    context.read<CartCubit>().addItem(
          CartItemModel(
            productId: product.id,
            productName: product.name,
            productImage: product.imageUrl,
            price: product.price,
            quantity: 1,
          ),
        );
    LDToast.show(
      context,
      message: '${product.name} added to cart',
      type: LDToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final unavailable = !product.isAvailable || !product.inStock;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Product image
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: ColorFiltered(
                    colorFilter: unavailable
                        ? const ColorFilter.mode(
                            Colors.white54, BlendMode.srcOver)
                        : const ColorFilter.mode(
                            Colors.transparent, BlendMode.multiply),
                    child: LDNetworkImage(
                      url: product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (unavailable)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Info section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Quantity + units
                  Text(
                    '${product.quantity} ${product.units}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  // Price row + add button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Struck-through original price — only if discount exists
                            if (product.hasDiscount)
                              Text(
                                '₹${product.originalPrice!.toInt()}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black38,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.black38,
                                ),
                              ),
                            // Sale / current price
                            Text(
                              '₹${product.price % 1 == 0 ? product.price.toInt() : product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: LDColors.primary,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: unavailable ? null : () => _addToCart(context),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: unavailable
                                ? Colors.grey.shade300
                                : LDColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: unavailable
                                ? Colors.grey.shade500
                                : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ), // Container
    ); // GestureDetector
  }
}
