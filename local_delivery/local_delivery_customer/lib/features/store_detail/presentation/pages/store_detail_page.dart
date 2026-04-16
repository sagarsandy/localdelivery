import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../cubit/store_detail_cubit.dart';
import '../../cubit/store_detail_state.dart';
import '../../domain/models/product_model.dart';
import '../../../home/domain/models/store_model.dart';

class StoreDetailPage extends StatelessWidget {
  const StoreDetailPage({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<StoreDetailCubit>()..loadStoreDetail(storeId),
      child: const _StoreDetailView(),
    );
  }
}

class _StoreDetailView extends StatelessWidget {
  const _StoreDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StoreDetailCubit, StoreDetailState>(
        builder: (context, state) {
          if (state is StoreDetailLoading) {
            return const LDLoadingWidget();
          }
          if (state is StoreDetailError) {
            return LDErrorWidget(
              message: state.message,
              onRetry: () {
                // retry — storeId accessible via parent context if needed
              },
            );
          }
          if (state is StoreDetailLoaded) {
            return _StoreDetailContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StoreDetailContent extends StatelessWidget {
  const _StoreDetailContent({required this.state});
  final StoreDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final store = state.store;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: LDNetworkImage(
              url: store.imageUrl,
              width: double.infinity,
              height: 220,
              borderRadius: 0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _StoreHeader(store: store),
          ),
        ),
        if (state.products.isEmpty)
          const SliverFillRemaining(
            child: LDEmptyStateWidget(
              title: 'No products available',
              subtitle: 'This store has no products right now.',
              icon: Icons.inventory_2_outlined,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ProductCard(
                  product: state.products[index],
                ),
                childCount: state.products.length,
              ),
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(store.name, style: context.headlineSmall),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: LDColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    store.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          store.description,
          style: context.bodyMedium.copyWith(color: LDColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, size: 14, color: LDColors.textSecondary),
            const SizedBox(width: 4),
            Text('${store.deliveryTimeMinutes} min', style: context.bodySmall),
            const SizedBox(width: 16),
            const Icon(Icons.delivery_dining, size: 14, color: LDColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              store.deliveryFee == 0
                  ? 'Free delivery'
                  : '₹${store.deliveryFee.toStringAsFixed(0)} delivery',
              style: context.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Text('Products', style: context.titleLarge),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/product/${product.id}', extra: {'product': product}),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LDNetworkImage(
                  url: product.imageUrl,
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: context.titleSmall),
                    if (product.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: context.bodySmall
                            .copyWith(color: LDColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: context.titleSmall
                              .copyWith(color: LDColors.primary),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '₹${product.originalPrice!.toStringAsFixed(0)}',
                            style: context.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: LDColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: LDColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
