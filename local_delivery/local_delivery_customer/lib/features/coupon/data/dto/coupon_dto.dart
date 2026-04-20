import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/coupon_model.dart';

class CouponDto {
  const CouponDto({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    required this.isActive,
    required this.expiryDate,
  });

  final String id;
  final String code;
  final String description;
  final String type;
  final int value;
  final bool isActive;
  final DateTime expiryDate;

  factory CouponDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CouponDto(
      id: doc.id,
      code: data['coupon'] as String? ?? '',
      description: data['description'] as String? ?? '',
      type: data['type'] as String? ?? 'amount',
      value: (data['value'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? false,
      expiryDate: data['expiryDate'] is Timestamp
          ? (data['expiryDate'] as Timestamp).toDate()
          : DateTime.now()
              .subtract(const Duration(days: 1)), // treat missing as expired
    );
  }

  CouponModel toDomain() => CouponModel(
        id: id,
        code: code,
        description: description,
        type: type,
        value: value,
        isActive: isActive,
        expiryDate: expiryDate,
      );
}
