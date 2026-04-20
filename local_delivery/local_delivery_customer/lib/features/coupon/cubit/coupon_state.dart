import 'package:equatable/equatable.dart';
import '../domain/models/coupon_model.dart';

abstract class CouponState extends Equatable {
  const CouponState();
  @override
  List<Object?> get props => [];
}

/// No coupon entered yet.
class CouponInitial extends CouponState {}

/// Validating the entered code against Firestore.
class CouponValidating extends CouponState {}

/// Coupon validated successfully — discount is ready.
class CouponApplied extends CouponState {
  const CouponApplied({
    required this.coupon,
    required this.discountAmount,
  });

  final CouponModel coupon;

  /// Actual rupee discount (already calculated for the current subtotal).
  final double discountAmount;

  @override
  List<Object?> get props => [coupon, discountAmount];
}

/// Validation failed — shows [message] below the input field.
class CouponError extends CouponState {
  const CouponError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
