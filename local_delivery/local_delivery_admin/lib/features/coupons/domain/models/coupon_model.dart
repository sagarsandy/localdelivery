import 'package:equatable/equatable.dart';

enum CouponType {
  amount,
  percentage;

  static CouponType fromString(String v) =>
      v == 'percentage' ? CouponType.percentage : CouponType.amount;

  String get label => this == CouponType.amount ? 'Amount (₹)' : 'Percentage (%)';
  String get symbol => this == CouponType.amount ? '₹' : '%';
}

class CouponModel extends Equatable {
  const CouponModel({
    required this.id,
    required this.coupon,
    required this.description,
    required this.type,
    required this.value,
    required this.isActive,
    required this.expiryDate,
  });

  final String id;

  /// The coupon code string (e.g. "SAVE50").
  final String coupon;
  final String description;
  final CouponType type;
  final int value;
  final bool isActive;
  final DateTime expiryDate;

  bool get isExpired => expiryDate.isBefore(DateTime.now());

  @override
  List<Object?> get props =>
      [id, coupon, description, type, value, isActive, expiryDate];
}
