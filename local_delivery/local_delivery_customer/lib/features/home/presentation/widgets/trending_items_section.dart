import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/trending_product_model.dart';

class TrendingItemsSection extends StatelessWidget {
  const TrendingItemsSection({super.key, required this.products});

  final List<TrendingProductModel> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LDEmptyStateWidget(
          title: 'No trending items',
          subtitle: 'Check back later for trending products.',
          icon: Icons.trending_up_outlined,
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _TrendingProductCard(product: products[index]);
        },
      ),
    );
  }
}

class _TrendingProductCard extends StatelessWidget {
  const _TrendingProductCard({required this.product});
  final TrendingProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: LDNetworkImage(
                url: product.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Text(
              product.name,
              style: context.bodySmall.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
