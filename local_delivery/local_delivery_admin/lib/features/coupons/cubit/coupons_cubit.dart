import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/coupon_model.dart';
import '../domain/use_cases/add_coupon_use_case.dart';
import '../domain/use_cases/delete_coupon_use_case.dart';
import '../domain/use_cases/get_coupons_use_case.dart';
import '../domain/use_cases/update_coupon_use_case.dart';
import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  CouponsCubit(
    this._getCoupons,
    this._addCoupon,
    this._updateCoupon,
    this._deleteCoupon,
  ) : super(CouponsInitial());

  final GetCouponsUseCase _getCoupons;
  final AddCouponUseCase _addCoupon;
  final UpdateCouponUseCase _updateCoupon;
  final DeleteCouponUseCase _deleteCoupon;

  List<CouponModel> _current = [];

  Future<void> loadCoupons() async {
    emit(CouponsLoading());
    final result = await _getCoupons.getCoupons();
    result.fold(
      (f) => emit(CouponsError(f.message)),
      (list) {
        _current = list;
        emit(CouponsLoaded(list));
      },
    );
  }

  Future<void> addCoupon(CouponModel coupon) async {
    emit(CouponActionInProgress(_current));
    final result = await _addCoupon.addCoupon(coupon);
    result.fold(
      (f) => emit(CouponActionError(coupons: _current, message: f.message)),
      (_) => _refresh('Coupon added successfully'),
    );
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    emit(CouponActionInProgress(_current));
    final result = await _updateCoupon.updateCoupon(coupon);
    result.fold(
      (f) => emit(CouponActionError(coupons: _current, message: f.message)),
      (_) => _refresh('Coupon updated successfully'),
    );
  }

  Future<void> deleteCoupon({required String id}) async {
    emit(CouponActionInProgress(_current));
    final result = await _deleteCoupon.deleteCoupon(id: id);
    result.fold(
      (f) => emit(CouponActionError(coupons: _current, message: f.message)),
      (_) => _refresh('Coupon deleted successfully'),
    );
  }

  Future<void> _refresh(String successMessage) async {
    final result = await _getCoupons.getCoupons();
    result.fold(
      (_) {},
      (list) => _current = list,
    );
    emit(CouponActionSuccess(coupons: _current, message: successMessage));
  }
}
