import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/use_cases/get_used_coupons_use_case.dart';
import 'coupon_details_state.dart';

class CouponDetailsCubit extends Cubit<CouponDetailsState> {
  CouponDetailsCubit(this._getUsedCoupons) : super(CouponDetailsInitial());

  final GetUsedCouponsUseCase _getUsedCoupons;

  Future<void> loadDetails({required String couponCode}) async {
    emit(CouponDetailsLoading());
    final result = await _getUsedCoupons.getUsedCoupons(couponCode: couponCode);
    result.fold(
      (f) => emit(CouponDetailsError(f.message)),
      (usages) {
        final totalDiscount =
            usages.fold<double>(0, (sum, u) => sum + u.value);
        emit(CouponDetailsLoaded(usages: usages, totalDiscount: totalDiscount));
      },
    );
  }
}
