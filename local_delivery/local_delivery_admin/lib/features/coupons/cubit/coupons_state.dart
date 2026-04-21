import 'package:equatable/equatable.dart';
import '../domain/models/coupon_model.dart';

abstract class CouponsState extends Equatable {
  const CouponsState();
  @override
  List<Object?> get props => [];
}

class CouponsInitial extends CouponsState {}

class CouponsLoading extends CouponsState {}

class CouponsLoaded extends CouponsState {
  const CouponsLoaded(this.coupons);
  final List<CouponModel> coupons;
  @override
  List<Object?> get props => [coupons];
}

class CouponsError extends CouponsState {
  const CouponsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class CouponActionInProgress extends CouponsState {
  const CouponActionInProgress(this.coupons);
  final List<CouponModel> coupons;
  @override
  List<Object?> get props => [coupons];
}

class CouponActionSuccess extends CouponsState {
  const CouponActionSuccess({required this.coupons, required this.message});
  final List<CouponModel> coupons;
  final String message;
  @override
  List<Object?> get props => [coupons, message];
}

class CouponActionError extends CouponsState {
  const CouponActionError({required this.coupons, required this.message});
  final List<CouponModel> coupons;
  final String message;
  @override
  List<Object?> get props => [coupons, message];
}
