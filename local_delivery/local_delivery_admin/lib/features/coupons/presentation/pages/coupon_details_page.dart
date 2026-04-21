import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../di/service_locator.dart';
import '../../cubit/coupon_details_cubit.dart';
import '../../cubit/coupon_details_state.dart';
import '../../domain/models/coupon_model.dart';
import '../../domain/models/used_coupon_model.dart';

class CouponDetailsPage extends StatelessWidget {
  const CouponDetailsPage({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<CouponDetailsCubit>()..loadDetails(couponCode: coupon.coupon),
      child: Scaffold(
        backgroundColor: LDColors.background,
        appBar: AppBar(
          backgroundColor: LDColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: LDColors.border,
          title: Text(coupon.coupon, style: context.titleLarge),
          leading: const BackButton(color: LDColors.textPrimary),
        ),
        body: BlocBuilder<CouponDetailsCubit, CouponDetailsState>(
          builder: (context, state) {
            if (state is CouponDetailsLoading) {
              return const LDLoadingWidget();
            }
            if (state is CouponDetailsError) {
              return LDErrorWidget(
                message: state.message,
                onRetry: () => context
                    .read<CouponDetailsCubit>()
                    .loadDetails(couponCode: coupon.coupon),
              );
            }
            if (state is CouponDetailsLoaded) {
              return _DetailsBody(coupon: coupon, state: state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.coupon, required this.state});

  final CouponModel coupon;
  final CouponDetailsLoaded state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Coupon summary card
                _CouponSummaryCard(coupon: coupon),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people_outline,
                        label: 'Total Usages',
                        value: state.totalUsages.toString(),
                        color: LDColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.savings_outlined,
                        label: 'Total Discount Given',
                        value: '₹${state.totalDiscount.toStringAsFixed(2)}',
                        color: LDColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (state.usages.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Usage History',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (state.usages.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 64, color: LDColors.textDisabled),
                  const SizedBox(height: 12),
                  Text(
                    'No usages yet',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: LDColors.textSecondary),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList.separated(
              itemCount: state.usages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) =>
                  _UsageRow(usage: state.usages[i], coupon: coupon),
            ),
          ),
      ],
    );
  }
}

class _CouponSummaryCard extends StatelessWidget {
  const _CouponSummaryCard({required this.coupon});
  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LDColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.confirmation_number_outlined,
                  color: LDColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                coupon.coupon,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: LDColors.primary,
                      letterSpacing: 1.5,
                    ),
              ),
            ],
          ),
          if (coupon.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(coupon.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: LDColors.textSecondary)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _SummaryChip(
                label: coupon.type == CouponType.amount
                    ? '₹${coupon.value} off'
                    : '${coupon.value}% off',
                color: LDColors.primary,
              ),
              _SummaryChip(
                label: coupon.type == CouponType.amount ? 'Amount' : 'Percentage',
                color: LDColors.textSecondary,
              ),
              _SummaryChip(
                label:
                    'Expires ${DateFormat('dd MMM yyyy').format(coupon.expiryDate)}',
                color: coupon.isExpired ? LDColors.error : LDColors.textSecondary,
              ),
              _SummaryChip(
                label: coupon.isActive ? 'Active' : 'Inactive',
                color: coupon.isActive ? LDColors.success : LDColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LDColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: LDColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.usage, required this.coupon});
  final UsedCouponModel usage;
  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: LDColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LDColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline,
                size: 20, color: LDColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usage.phone,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(usage.date),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: LDColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '−₹${usage.value.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: LDColors.success,
                    ),
              ),
              Text(
                'discount',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: LDColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
