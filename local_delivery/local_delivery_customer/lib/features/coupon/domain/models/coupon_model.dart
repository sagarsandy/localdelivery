import 'package:equatable/equatable.dart';

class CouponModel extends Equatable {
  const CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    required this.isActive,
    required this.expiryDate,
  });

  final String id;

  /// The coupon code string (e.g. "SAVE50").
  final String code;

  final String description;

  /// 'amount' → fixed rupee discount  |  'percentage' → % off subtotal.
  final String type;

  /// Discount value: rupees for 'amount', percent for 'percentage'.
  final int value;

  final bool isActive;
  final DateTime expiryDate;

  // ─── Helpers ─────────────────────────────────────────────────────────────

  bool get isPercentage => type == 'percentage';
  bool get isAmount => type == 'amount';
  bool get isExpired => expiryDate.isBefore(DateTime.now());

  /// Calculates the actual rupee discount for a given [subtotal].
  /// The discount is capped so the order total never goes below zero.
  double discountFor(double subtotal) {
    final raw = isPercentage ? (subtotal * value) / 100 : value.toDouble();
    return raw > subtotal ? subtotal : raw;
  }

  @override
  List<Object?> get props => [id, code, type, value, isActive, expiryDate];
}
