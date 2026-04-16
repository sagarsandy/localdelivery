import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../di/service_locator.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../widgets/categories_section.dart';
import '../widgets/fresh_subcategories_section.dart';
import '../widgets/section_header_widget.dart';
import '../widgets/trending_items_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<HomeCubit>()..loadHome(),
      child: const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: _HomeBody(),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

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
        if (state is HomeLoaded) return _HomeContent(state: state);
        return const SizedBox.shrink();
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});
  final HomeLoaded state;

  void _showComingSoon(BuildContext context) {
    LDToast.show(context, message: 'Coming soon!', type: LDToastType.info);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(child: _HomeHeader(context: context)),

        // Search bar
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
                    const Icon(Icons.search, color: LDColors.textSecondary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Search by name',
                      style: context.bodyMedium.copyWith(color: LDColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Fresh Picks section
        SliverToBoxAdapter(
          child: SectionHeaderWidget(
            title: 'Fresh Picks',
            onViewAll: () => _showComingSoon(context),
          ),
        ),
        SliverToBoxAdapter(
          child: FreshSubcategoriesSection(subcategories: state.freshSubcategories),
        ),

        // Trending Items section
        SliverToBoxAdapter(
          child: SectionHeaderWidget(
            title: 'Trending Items',
            onViewAll: () => _showComingSoon(context),
          ),
        ),
        SliverToBoxAdapter(
          child: TrendingItemsSection(products: state.trendingProducts),
        ),

        // Categories section
        SliverToBoxAdapter(
          child: SectionHeaderWidget(
            title: 'Categories',
            onViewAll: () => _showComingSoon(context),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          sliver: SliverToBoxAdapter(
            child: CategoriesSection(categories: state.categories),
          ),
        ),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: LDColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on, color: LDColors.primary, size: 20),
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
                  Text(
                    '123 Green Valley, Bangalore',
                    style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push(LDAppRoute.profile.path),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: LDColors.surfaceVariant,
                child: Icon(Icons.person, color: LDColors.textSecondary, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
