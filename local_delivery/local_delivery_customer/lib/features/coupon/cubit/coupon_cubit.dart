import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/session/user_session.dart';
import '../domain/use_cases/validate_coupon_use_case.dart';
import 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit(this._validateCouponUseCase) : super(CouponInitial());

  final ValidateCouponUseCase _validateCouponUseCase;

  /// Validates [code] against Firestore and calculates the discount for
  /// [subtotal]. Emits [CouponApplied] on success, [CouponError] on failure.
  Future<void> applyCoupon({
    required String code,
    required double subtotal,
  }) async {
    if (code.trim().isEmpty) {
      emit(const CouponError('Please enter a coupon code.'));
      return;
    }

    final phone = UserSession.instance.phoneNumber ?? '';
    if (phone.isEmpty) {
      emit(const CouponError('Unable to verify user. Please try again.'));
      return;
    }

    emit(CouponValidating());

    final result = await _validateCouponUseCase.validateCoupon(
      code: code.trim().toUpperCase(),
      phone: phone,
    );

    result.fold(
      (failure) => emit(CouponError(failure.message)),
      (coupon) => emit(CouponApplied(
        coupon: coupon,
        discountAmount: coupon.discountFor(subtotal),
      )),
    );
  }

  /// Removes the applied coupon and resets to initial state.
  void removeCoupon() => emit(CouponInitial());
}
