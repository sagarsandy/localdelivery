import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../core/widgets/ld_confirm_dialog.dart';
import '../../../../di/service_locator.dart';
import '../../cubit/coupons_cubit.dart';
import '../../cubit/coupons_state.dart';
import '../../domain/models/coupon_model.dart';
import '../widgets/add_edit_coupon_sheet_widget.dart';
import '../widgets/coupon_card_widget.dart';
import '../widgets/coupons_empty_widget.dart';
import 'coupon_details_page.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  bool _isSheetOpen = false;

  void _showSheet(BuildContext context, {CouponModel? coupon}) {
    final cubit = context.read<CouponsCubit>();
    setState(() => _isSheetOpen = true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: LDColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddEditCouponSheetWidget(coupon: coupon),
      ),
    ).whenComplete(() => setState(() => _isSheetOpen = false));
  }

  Future<void> _confirmDelete(
      BuildContext context, CouponModel coupon) async {
    final confirmed = await LDConfirmDialog.show(
      context,
      title: 'Delete Coupon',
      message: 'Delete "${coupon.coupon}"? This cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: LDColors.error,
      icon: Icons.delete_outline,
    );
    if (confirmed == true && context.mounted) {
      context.read<CouponsCubit>().deleteCoupon(id: coupon.id);
    }
  }

  void _openDetails(BuildContext context, CouponModel coupon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CouponDetailsPage(coupon: coupon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CouponsCubit>()..loadCoupons(),
      child: BlocConsumer<CouponsCubit, CouponsState>(
        listener: (context, state) {
          if (state is CouponActionSuccess) {
            if (_isSheetOpen) Navigator.of(context).pop();
            LDToast.show(context,
                message: state.message, type: LDToastType.success);
          } else if (state is CouponActionError) {
            LDToast.show(context,
                message: state.message, type: LDToastType.error);
          }
        },
        builder: (context, state) {
          final coupons = switch (state) {
            CouponsLoaded(coupons: final c) => c,
            CouponActionInProgress(coupons: final c) => c,
            CouponActionSuccess(coupons: final c) => c,
            CouponActionError(coupons: final c) => c,
            _ => null,
          };

          return Stack(
            children: [
              if (state is CouponsLoading && coupons == null)
                const LDLoadingWidget()
              else if (state is CouponsError)
                LDErrorWidget(
                  message: state.message,
                  onRetry: () =>
                      context.read<CouponsCubit>().loadCoupons(),
                )
              else if (coupons != null && coupons.isEmpty)
                const CouponsEmptyWidget()
              else if (coupons != null)
                _CouponsList(
                  coupons: coupons,
                  isMutating: state is CouponActionInProgress,
                  onTap: (c) => _openDetails(context, c),
                  onEdit: (c) => _showSheet(context, coupon: c),
                  onDelete: (c) => _confirmDelete(context, c),
                ),
              if (coupons != null)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: state is CouponActionInProgress
                        ? null
                        : () => _showSheet(context),
                    backgroundColor: LDColors.primary,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Coupon',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CouponsList extends StatelessWidget {
  const _CouponsList({
    required this.coupons,
    required this.isMutating,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CouponModel> coupons;
  final bool isMutating;
  final ValueChanged<CouponModel> onTap;
  final ValueChanged<CouponModel> onEdit;
  final ValueChanged<CouponModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
          itemCount: coupons.length,
          itemBuilder: (_, i) {
            final c = coupons[i];
            return CouponCardWidget(
              coupon: c,
              onTap: () => onTap(c),
              onEdit: () => onEdit(c),
              onDelete: () => onDelete(c),
            );
          },
        ),
        if (isMutating)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33000000),
              child: Center(
                child: CircularProgressIndicator(color: LDColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}
