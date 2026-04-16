import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/order_model.dart';

class OrderDto {
  const OrderDto({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.deliveryFee,
    required this.createdAt,
    required this.itemCount,
  });

  final String id;
  final String userId;
  final String status;
  final double totalAmount;
  final double deliveryFee;
  final DateTime createdAt;
  final int itemCount;

  factory OrderDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderDto(
      id: doc.id,
      userId: data['user_id'] as String,
      status: data['status'] as String? ?? 'pending',
      totalAmount: (data['total_amount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (data['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      createdAt: _toDateTime(data['created_at']),
      itemCount: data['item_count'] as int? ?? 0,
    );
  }

  factory OrderDto.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderDto(
      id: doc.id,
      userId: data['user_id'] as String,
      status: data['status'] as String? ?? 'pending',
      totalAmount: (data['total_amount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (data['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      createdAt: _toDateTime(data['created_at']),
      itemCount: data['item_count'] as int? ?? 0,
    );
  }

  OrderModel toDomain() => OrderModel(
        id: id,
        userId: userId,
        status: status,
        totalAmount: totalAmount,
        deliveryFee: deliveryFee,
        createdAt: createdAt,
        itemCount: itemCount,
      );

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
