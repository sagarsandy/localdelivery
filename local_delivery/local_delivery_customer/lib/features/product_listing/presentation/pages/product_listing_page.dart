import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../di/service_locator.dart';
import '../../../../features/cart/cubit/cart_cubit.dart';
import '../../cubit/product_listing_cubit.dart';
import '../../cubit/product_listing_state.dart';
import '../../domain/models/product_model.dart';
import '../widgets/product_card_widget.dart';

class ProductListingPage extends StatelessWidget {
  const ProductListingPage({
    super.key,
    required this.subcategoryId,
    required this.subcategoryName,
  });

  final String subcategoryId;
  final String subcategoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ProductListingCubit>()
        ..loadProducts(subcategoryId: subcategoryId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: _ProductListingBodyWidget(
          subcategoryId: subcategoryId,
          subcategoryName: subcategoryName,
        ),
      ),
    );
  }
}

class _ProductListingBodyWidget extends StatelessWidget {
  const _ProductListingBodyWidget({
    required this.subcategoryId,
    required this.subcategoryName,
  });

  final String subcategoryId;
  final String subcategoryName;

  void _navigateToDetail(BuildContext context, ProductModel product) {
    context.push(
      LDAppRoute.productDetail.path.replaceFirst(':productId', product.id),
      extra: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListingCubit, ProductListingState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            // ── App bar
            SliverAppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              pinned: true,
              title: Text(
                subcategoryName,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded, size: 24),
                  onPressed: () => LDToast.show(
                    context,
                    message: 'Search coming soon!',
                    type: LDToastType.info,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ),
            ),

            // ── Content
            if (state is ProductListingLoading)
              const SliverFillRemaining(
                child: LDLoadingWidget(),
              )
            else if (state is ProductListingError)
              SliverFillRemaining(
                child: LDErrorWidget(
                  message: state.message,
                  onRetry: () => context
                      .read<ProductListingCubit>()
                      .loadProducts(subcategoryId: subcategoryId),
                ),
              )
            else if (state is ProductListingLoaded && state.products.isEmpty)
              const SliverFillRemaining(
                child: _EmptyProductsWidget(),
              )
            else if (state is ProductListingLoaded)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = state.products[index];
                      return BlocProvider.value(
                        value: locator<CartCubit>(),
                        child: ProductCardWidget(
                          product: product,
                          onTap: () => _navigateToDetail(context, product),
                        ),
                      );
                    },
                    childCount: state.products.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyProductsWidget extends StatelessWidget {
  const _EmptyProductsWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 72,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No products available',
            style: context.titleMedium.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new arrivals',
            style: context.bodySmall.copyWith(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
