import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../di/service_locator.dart';
import '../../../address/cubit/address_cubit.dart';
import '../../../address/cubit/address_state.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../../domain/models/subcategory_model.dart';
import '../widgets/categories_section_widget.dart';
import '../widgets/category_subcategories_section_widget.dart';
import '../widgets/section_header_widget.dart';
import '../widgets/trending_items_section_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => locator<HomeCubit>()..loadHome(),
        ),
        BlocProvider.value(
          value: locator<AddressCubit>(),
        ),
      ],
      child: const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: _HomeBodyWidget(),
      ),
    );
  }
}

class _HomeBodyWidget extends StatelessWidget {
  const _HomeBodyWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) return const LDLoadingWidget();
        if (state is HomeError) {
          return LDErrorWidget(
            message: state.message,
            onRetry: () => context.read<HomeCubit>().loadHome(),
          );
        }
        if (state is HomeLoaded) return _HomeContentWidget(state: state);
        return const SizedBox.shrink();
      },
    );
  }
}

class _HomeContentWidget extends StatelessWidget {
  const _HomeContentWidget({required this.state});
  final HomeLoaded state;

  void _showComingSoon(BuildContext context) {
    LDToast.show(context, message: 'Coming soon!', type: LDToastType.info);
  }

  void _navigateToProducts(BuildContext context, SubcategoryModel subcategory) {
    context.push(
      '${LDAppRoute.productListing.path.replaceFirst(':subcategoryId', subcategory.name)}'
      '?name=${Uri.encodeComponent(subcategory.name)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorySections = state.categories
        .where((cat) {
          final key = cat.name.toLowerCase();
          return state.subcategoriesByCategory.containsKey(key) &&
              state.subcategoriesByCategory[key]!.isNotEmpty;
        })
        .map((cat) => (
              displayName: cat.name,
              subcategories:
                  state.subcategoriesByCategory[cat.name.toLowerCase()]!,
            ))
        .toList();

    return CustomScrollView(
      slivers: [
        // ── Header (shows active address)
        const SliverToBoxAdapter(child: _HomeHeaderWidget()),

        // ── Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GestureDetector(
              onTap: () => _showComingSoon(context),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search,
                        color: LDColors.textSecondary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Search by name',
                      style: context.bodyMedium
                          .copyWith(color: LDColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Trending Items section
        SliverToBoxAdapter(
          child: SectionHeaderWidget(
            title: 'Trending Items',
            onViewAll: () => _showComingSoon(context),
          ),
        ),
        SliverToBoxAdapter(
          child: TrendingItemsSectionWidget(products: state.trendingProducts),
        ),

        // ── Per-category subcategory sections
        for (int i = 0; i < categorySections.length; i++)
          SliverToBoxAdapter(
            child: CategorySubcategoriesSectionWidget(
              categoryName: categorySections[i].displayName,
              subcategories: categorySections[i].subcategories,
              onViewAll: () => _showComingSoon(context),
              onSubcategoryTap: (sub) => _navigateToProducts(context, sub),
              index: i,
            ),
          ),

        // ── All Categories section (bottom)
        SliverToBoxAdapter(
          child: SectionHeaderWidget(
            title: 'All Categories',
            onViewAll: () => _showComingSoon(context),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          sliver: SliverToBoxAdapter(
            child: CategoriesSectionWidget(categories: state.categories),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header — shows the active delivery address from AddressCubit singleton
// ─────────────────────────────────────────────────────────────────────────────
class _HomeHeaderWidget extends StatelessWidget {
  const _HomeHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: BlocBuilder<AddressCubit, AddressState>(
          builder: (context, addressState) {
            final active = addressState is AddressLoaded
                ? addressState.activeAddress
                : null;

            final addressText = active != null
                ? active.shortAddress
                : 'Set delivery address';

            final isLoading = addressState is AddressLoading;

            return Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: LDColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on,
                      color: LDColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'DELIVERY TO',
                        style: context.labelSmall.copyWith(
                          color: LDColors.textSecondary,
                          letterSpacing: 0.8,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      isLoading
                          ? Container(
                              width: 140,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : Text(
                              addressText,
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: active != null
                                    ? Colors.black87
                                    : Colors.black45,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
