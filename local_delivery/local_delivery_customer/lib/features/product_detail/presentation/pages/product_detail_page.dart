import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../../store_detail/domain/models/product_model.dart';
import '../../cubit/product_detail_cubit.dart';
import '../../cubit/product_detail_state.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<ProductDetailCubit>()..loadProductDetail(productId),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) return const LDLoadingWidget();
          if (state is ProductDetailError) {
            return LDErrorWidget(
              message: state.message,
              onRetry: () {},
            );
          }
          if (state is ProductDetailLoaded) {
            return _ProductDetailContent(product: state.product);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductDetailContent extends StatefulWidget {
  const _ProductDetailContent({required this.product});
  final ProductModel product;

  @override
  State<_ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<_ProductDetailContent> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LDNetworkImage(
                  url: product.imageUrl,
                  width: double.infinity,
                  height: 260,
                  borderRadius: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: context.headlineSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: context.titleLarge
                                .copyWith(color: LDColors.primary),
                          ),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '₹${product.originalPrice!.toStringAsFixed(0)}',
                              style: context.bodyMedium.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: LDColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (product.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text('Description', style: context.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          style: context.bodyMedium
                              .copyWith(color: LDColors.textSecondary),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Quantity', style: context.titleSmall),
                          LDCartQuantityButton(
                            quantity: _quantity,
                            onIncrement: () =>
                                setState(() => _quantity++),
                            onDecrement: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: LDButton(
              label: 'Add to Cart — ₹${(product.price * _quantity).toStringAsFixed(0)}',
              onPressed: () {
                final item = CartItemModel(
                  productId: product.id,
                  productName: product.name,
                  productImage: product.imageUrl,
                  storeId: product.storeId,
                  storeName: '',
                  price: product.price,
                  quantity: _quantity,
                );
                locator<CartCubit>().addItem(item);
                LDToast.show(
                  context,
                  message: 'Added to cart',
                  type: LDToastType.success,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
