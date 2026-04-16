import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../../domain/models/store_model.dart';
import '../../domain/models/category_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<HomeCubit>()..loadHome(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Local Delivery'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => context.push(LDAppRoute.cart.path),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.push(LDAppRoute.profile.path),
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) return const LDLoadingWidget();
            if (state is HomeError) {
              return LDErrorWidget(
                message: state.message,
                onRetry: () => context.read<HomeCubit>().loadHome(),
              );
            }
            if (state is HomeLoaded) {
              return _HomeContent(state: state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});
  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: LDTextField(
              hint: 'Search stores or products...',
              prefixIcon: const Icon(Icons.search),
              readOnly: true,
              onTap: () {/* TODO: navigate to search */},
            ),
          ),
        ),
        // Categories
        SliverToBoxAdapter(
          child: _CategoriesRow(
            categories: state.categories,
            selectedId: state.selectedCategoryId,
          ),
        ),
        // Store list header
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Text('Stores near you', style: context.titleLarge),
          ),
        ),
        // Stores
        state.stores.isEmpty
            ? const SliverFillRemaining(
                child: LDEmptyStateWidget(
                  title: 'No stores found',
                  subtitle: 'Try a different category or check back later.',
                  icon: Icons.store_outlined,
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _StoreCard(store: state.stores[index]),
                    childCount: state.stores.length,
                  ),
                ),
              ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  const _CategoriesRow({required this.categories, this.selectedId});
  final List<CategoryModel> categories;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = selectedId == cat.id;
          return GestureDetector(
            onTap: () => context.read<HomeCubit>().filterByCategory(
                  selected ? null : cat.id,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selected ? LDColors.primary : LDColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: LDNetworkImage(url: cat.imageUrl, width: 60, height: 60),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat.name,
                  style: context.labelSmall.copyWith(
                    color: selected ? LDColors.primary : LDColors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          '/store/${store.id}',
          extra: {'store': store},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LDNetworkImage(
              url: store.imageUrl,
              width: double.infinity,
              height: 160,
              borderRadius: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(store.name, style: context.titleMedium),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: LDColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.white),
                            const SizedBox(width: 3),
                            Text(
                              store.rating.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: LDColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${store.deliveryTimeMinutes} min', style: context.bodySmall),
                      const SizedBox(width: 12),
                      const Icon(Icons.delivery_dining, size: 14, color: LDColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        store.deliveryFee == 0 ? 'Free delivery' : '₹${store.deliveryFee.toStringAsFixed(0)} delivery',
                        style: context.bodySmall,
                      ),
                    ],
                  ),
                  if (!store.isOpen) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: LDColors.statusCancelled,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Closed',
                        style: context.labelSmall.copyWith(color: LDColors.statusCancelledText),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
