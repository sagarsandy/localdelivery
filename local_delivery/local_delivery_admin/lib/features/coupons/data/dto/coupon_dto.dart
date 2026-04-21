import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/coupon_model.dart';

class CouponDto {
  const CouponDto({
    required this.id,
    required this.coupon,
    required this.description,
    required this.type,
    required this.value,
    required this.isActive,
    required this.expiryDate,
  });

  final String id;
  final String coupon;
  final String description;
  final String type;
  final int value;
  final bool isActive;
  final DateTime expiryDate;

  factory CouponDto.fromFirestore(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CouponDto(
      id: doc.id,
      coupon: d['coupon'] as String? ?? '',
      description: d['description'] as String? ?? '',
      type: d['type'] as String? ?? 'amount',
      value: (d['value'] as num?)?.toInt() ?? 0,
      isActive: d['isActive'] as bool? ?? true,
      expiryDate: (d['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  CouponModel toDomain() => CouponModel(
        id: id,
        coupon: coupon,
        description: description,
        type: CouponType.fromString(type),
        value: value,
        isActive: isActive,
        expiryDate: expiryDate,
      );

  static Map<String, dynamic> fromModel(CouponModel m) => {
        'coupon': m.coupon.trim().toUpperCase(),
        'description': m.description.trim(),
        'type': m.type.name,
        'value': m.value,
        'isActive': m.isActive,
        'expiryDate': Timestamp.fromDate(m.expiryDate),
      };
}
