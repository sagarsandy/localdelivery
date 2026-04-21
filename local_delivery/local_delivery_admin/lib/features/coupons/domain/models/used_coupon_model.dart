import 'package:equatable/equatable.dart';

class UsedCouponModel extends Equatable {
  const UsedCouponModel({
    required this.id,
    required this.coupon,
    required this.phone,
    required this.date,
    required this.value,
  });

  final String id;

  /// Coupon code this usage belongs to.
  final String coupon;
  final String phone;
  final DateTime date;

  /// Actual discount amount given to this customer.
  final double value;

  @override
  List<Object?> get props => [id, coupon, phone, date, value];
}
