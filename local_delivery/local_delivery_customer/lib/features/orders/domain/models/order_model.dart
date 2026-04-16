import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.storeName,
    required this.status,
    required this.totalAmount,
    required this.deliveryFee,
    required this.createdAt,
    required this.itemCount,
  });

  final String id;
  final String userId;
  final String storeId;
  final String storeName;
  final String status;
  final double totalAmount;
  final double deliveryFee;
  final DateTime createdAt;
  final int itemCount;

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        storeId: map['store_id'] as String,
        storeName: map['store_name'] as String? ?? '',
        status: map['status'] as String? ?? 'pending',
        totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
        deliveryFee: (map['delivery_fee'] as num?)?.toDouble() ?? 0.0,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : DateTime.now(),
        itemCount: map['item_count'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'store_id': storeId,
        'store_name': storeName,
        'status': status,
        'total_amount': totalAmount,
        'delivery_fee': deliveryFee,
        'created_at': createdAt.toIso8601String(),
        'item_count': itemCount,
      };

  @override
  List<Object?> get props => [id, status, totalAmount];
}
