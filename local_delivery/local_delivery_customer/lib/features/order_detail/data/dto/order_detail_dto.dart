import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/order_detail_model.dart';
import '../../../orders/data/dto/order_dto.dart';

class OrderItemDto {
  const OrderItemDto({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String productId;
  final String name;
  final double price;
  final int quantity;

  factory OrderItemDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderItemDto(
      productId: data['product_id'] as String,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] as int,
    );
  }

  OrderItemModel toDomain() => OrderItemModel(
        productId: productId,
        name: name,
        price: price,
        quantity: quantity,
      );
}

class OrderDetailDto {
  const OrderDetailDto({
    required this.order,
    required this.items,
    required this.address,
    required this.paymentMethod,
  });

  final OrderDto order;
  final List<OrderItemDto> items;
  final String address;
  final String paymentMethod;

  OrderDetailModel toDomain() => OrderDetailModel(
        id: order.id,
        userId: order.userId,
        storeId: order.storeId,
        storeName: order.storeName,
        status: order.status,
        totalAmount: order.totalAmount,
        deliveryFee: order.deliveryFee,
        createdAt: order.createdAt,
        itemCount: order.itemCount,
        items: items.map((e) => e.toDomain()).toList(),
        address: address,
        paymentMethod: paymentMethod,
      );
}
