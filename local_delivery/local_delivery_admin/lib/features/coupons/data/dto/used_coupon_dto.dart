import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/used_coupon_model.dart';

class UsedCouponDto {
  const UsedCouponDto({
    required this.id,
    required this.coupon,
    required this.phone,
    required this.date,
    required this.value,
  });

  final String id;
  final String coupon;
  final String phone;
  final DateTime date;
  final double value;

  factory UsedCouponDto.fromFirestore(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return UsedCouponDto(
      id: doc.id,
      coupon: d['coupon'] as String? ?? '',
      phone: d['phone'] as String? ?? '',
      date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      value: (d['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  UsedCouponModel toDomain() => UsedCouponModel(
        id: id,
        coupon: coupon,
        phone: phone,
        date: date,
        value: value,
      );
}
