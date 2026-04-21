import 'package:equatable/equatable.dart';
import '../domain/models/used_coupon_model.dart';

abstract class CouponDetailsState extends Equatable {
  const CouponDetailsState();
  @override
  List<Object?> get props => [];
}

class CouponDetailsInitial extends CouponDetailsState {}

class CouponDetailsLoading extends CouponDetailsState {}

class CouponDetailsLoaded extends CouponDetailsState {
  const CouponDetailsLoaded({
    required this.usages,
    required this.totalDiscount,
  });

  final List<UsedCouponModel> usages;
  final double totalDiscount;
  int get totalUsages => usages.length;

  @override
  List<Object?> get props => [usages, totalDiscount];
}

class CouponDetailsError extends CouponDetailsState {
  const CouponDetailsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
